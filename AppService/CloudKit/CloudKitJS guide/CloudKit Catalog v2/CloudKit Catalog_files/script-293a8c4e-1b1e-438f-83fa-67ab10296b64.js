CKCatalog.dialog=(function(){var self={};var el=document.getElementById('dialog');el.setAttribute('tabindex','0');el.addEventListener('click',function(ev){var target=ev.target;if(target&&target.id==='dialog'&&target.classList.contains('dismissable')){self.hide();}});document.addEventListener('keyup',function(ev){var code=ev.which||ev.keyCode;if(code==27&&el.classList.contains('dismissable')){self.hide();}});var textEl=document.getElementById('dialog-text');self.hide=function(){el.classList.add('hide');el.classList.remove('dismissable');};var createDismissButton=function(){var dismissBtn=document.createElement('button');dismissBtn.className='link';dismissBtn.textContent='Close';dismissBtn.onclick=self.hide;dismissBtn.setAttribute('tabindex','1');return dismissBtn;};var actions=document.createElement('div');actions.className='actions';actions.appendChild(createDismissButton());var customDismissButton=document.createElement('button');customDismissButton.className='link default-action';customDismissButton.setAttribute('tabindex','0');var customActions=document.createElement('div');customActions.className='actions';customActions.appendChild(createDismissButton());customActions.appendChild(customDismissButton);var positionTextEl=function(){var rect=textEl.getBoundingClientRect();textEl.style.left='calc(50% - '+(rect.width/2)+'px)';textEl.style.top='calc(50% - '+(rect.height/2)+'px)';};self.show=function(textOrElement,dismissButtonOptions){el.classList.remove('hide');el.focus();if(typeof textOrElement==='string'){textEl.innerHTML=textOrElement;}else{textEl.innerHTML='';textEl.appendChild(textOrElement);}
if(dismissButtonOptions){textEl.classList.remove('no-actions');el.classList.add('dismissable');customDismissButton.textContent=dismissButtonOptions.title;customDismissButton.onclick=function(){self.hide();dismissButtonOptions.action&&dismissButtonOptions.action();};textEl.appendChild(customActions);}else{textEl.classList.add('no-actions');}
positionTextEl();};self.showError=function(error){el.classList.remove('hide');el.classList.add('dismissable');textEl.classList.remove('no-actions');if(error.ckErrorCode){textEl.innerHTML='<h2>Error: <span class="error-code">'+error.ckErrorCode+'</span></h2>'+
'<p class="error">'+
(error.reason?'Reason: '+error.reason:(error.message||'An error occurred.'))+
'</p>';}else{var message=error.message||'An unexpected error occurred.';textEl.innerHTML='<h2>Error</h2>'+
'<p class="error">'+message+'</p>';}
textEl.appendChild(actions);positionTextEl();};return self;})();CKCatalog.Table=function(heading){this.el=document.createElement('div');this.el.className='table-wrapper';this._numberOfColumns=2;this._rows=[];this._heading=heading||[];this._rowIsSelectable=function(){return false;};this._selectHandler=function(){};var table=document.createElement('table');if(heading&&Array.isArray(heading)){this._numberOfColumns=heading.length;var head=table.appendChild(document.createElement('thead'));var tr=head.appendChild(document.createElement('tr'));heading.forEach(function(name){var th=document.createElement('th');th.textContent=name;tr.appendChild(th);});this.body=table.appendChild(document.createElement('tbody'));}else{this.body=table;}
this.el.appendChild(table);};CKCatalog.Table.prototype.clearAllRows=function(){this._rows=[];this.body.innerHTML='';return this;};CKCatalog.Table.prototype.renderObject=function(object){for(var k in object){if(object.hasOwnProperty(k)){this.appendRow(k,object[k]);}}
return this;};CKCatalog.Table.prototype.setTextForUndefinedValue=function(text){this._textForUndefinedValue=text;return this;};CKCatalog.Table.prototype.setTextForEmptyRow=function(text){this._textForEmptyRow=text;return this;};CKCatalog.Table.prototype._textForUndefinedValue='-';CKCatalog.Table.prototype._textForEmptyRow='No Content';CKCatalog.Table.prototype._createRowWithKey=function(key){var tr=document.createElement('tr');var th=document.createElement('th');th.textContent=key;tr.appendChild(th);return tr;};CKCatalog.Table.prototype._createRowWithValues=function(values,boolArray,opts){var tr=document.createElement('tr');var that=this;opts=opts||{};values.forEach(function(value,index){var td;if(value===null||value===undefined){td=that._createEmptyValueCell();}else{td=document.createElement('td');if(boolArray&&!boolArray[index]){if(typeof value==='object'&&!(value instanceof Date)){td.appendChild(that._createPrettyObject(value));}else{td.appendChild(that._createPrettyElementForTypedValue(value,opts.type));}}else{td.innerHTML=value;}}
tr.appendChild(td);});return tr;};CKCatalog.Table.prototype._createEmptyRow=function(){var tr=document.createElement('tr');tr.innerHTML='<td class="light align-center" colspan="'+
this._numberOfColumns+'">'+this._textForEmptyRow+'</td>';tr.className='empty';return tr;};CKCatalog.Table.prototype._createEmptyValueCell=function(){var td=document.createElement('td');var span=document.createElement('span');span.className='light';span.textContent=this._textForUndefinedValue;td.appendChild(span);return td;};CKCatalog.Table.prototype._prettyPrintValue=function(value){if(value instanceof Date){return value.toLocaleString();}else if(typeof value==='object'){return JSON.stringify(value,null,'  ').replace(/^{\n/,'').replace(/}$/,'');}else{return value;}};CKCatalog.Table.prototype._createPrettyElementForTypedValue=function(value,type){var el=document.createElement('div');el.className='ellipsis max-width-500';if(type===CKCatalog.FIELD_TYPE_BYTES){el.appendChild(this._createDownloadLinkFromBase64String(value));}else if(type===CKCatalog.FIELD_TYPE_TIMESTAMP){el.textContent=(new Date(value)).toLocaleString();}else{el.textContent=value;}
return el;};CKCatalog.Table.prototype._createPrettyObject=function(object,opts){var el;opts=opts||{};if(Array.isArray(object)){var that=this;if(object.length){el=document.createElement('ol');el.className='object array';object.forEach(function(item){var li=document.createElement('li');if(typeof item!=='string'&&typeof item!=='number'){li.className='array-item';}
li.appendChild(that._createPrettyObject(item,opts));el.appendChild(li);});}else{el=document.createElement('div');el.textContent=this._textForUndefinedValue;}}else if(typeof object==='object'){el=document.createElement('div');el.className='object';for(var k in object){if(object.hasOwnProperty(k)){var wrapper=document.createElement('div');var key=document.createElement('span');key.className='object-key';key.textContent=k+':';var val;if(typeof object[k]==='object'&&!(object[k]instanceof Date)){val=document.createElement('pre');}else{val=document.createElement('span');}
val.className='object-value';if(k==='downloadURL'&&object[k]){val.classList.add('download-url');wrapper.classList.add('max-width-500');val.innerHTML='<a class="link" href="'+object[k]+'" download>'+object[k]+'</a>';}else{val.textContent=this._prettyPrintValue(object[k]);}
wrapper.appendChild(key);wrapper.appendChild(val);el.appendChild(wrapper);}}}else{el=this._createPrettyElementForTypedValue(object,opts.type);}
return el;};CKCatalog.Table.prototype._createDownloadLinkFromBase64String=function(base64String){var link=document.createElement('a');link.setAttribute('download','');link.setAttribute('href','data:application/octet-stream;base64,'+base64String);link.textContent=base64String.substr(0,20)+'…';return link;};CKCatalog.Table.prototype._createRow=function(keyOrValues,value,opts){var tr;opts=opts||{};if(Array.isArray(keyOrValues)){if(keyOrValues.length===0){tr=this._createEmptyRow();}else{tr=this._createRowWithValues(keyOrValues,[],opts);}}else{tr=this._createRowWithKey(keyOrValues);var td;if(value===null||value===undefined){td=this._createEmptyValueCell();}else{td=document.createElement('td');if(typeof value==='object'&&!(value instanceof Date)){td.appendChild(this._createPrettyObject(value,opts));}else{td.appendChild(this._createPrettyElementForTypedValue(value,opts.type));}}
tr.appendChild(td);}
return tr;};CKCatalog.Table.prototype._createDataHash=function(keyOrValues,value){var data={};if(Array.isArray(keyOrValues)){this._heading.forEach(function(key,index){data[key]=keyOrValues[index];});}else{data[keyOrValues]=value;}
return data;};CKCatalog.Table.prototype._addHandlersToRow=function(row){if(this._rowIsSelectable(row)){row.el.classList.add('selectable');var handler=this._selectHandler;row.el.onclick=function(){handler(row);};}};CKCatalog.Table.prototype.appendRow=function(keyOrValues,value,opts){var tr=this._createRow(keyOrValues,value,opts);this.body.appendChild(tr);var row={data:this._createDataHash(keyOrValues,value),el:tr};this._rows.push(row);this._addHandlersToRow(row);return this;};CKCatalog.Table.prototype.prependRow=function(keyOrValues,value){var tr=this._createRow(keyOrValues,value);this.body.insertBefore(tr,this.body.firstChild);var row={data:this._createDataHash(keyOrValues,value),el:tr};this._rows.unshift(row);this._addHandlersToRow(row);return this;};CKCatalog.Table.prototype.rowIsSelectable=function(condition){this._rowIsSelectable=condition;return this;};CKCatalog.Table.prototype.addSelectHandler=function(handler){this._selectHandler=handler;return this;};(function(){var constants={FIELD_TYPE_STRING:'STRING',FIELD_TYPE_LOCATION:'LOCATION',FIELD_TYPE_ASSET:'ASSETID',FIELD_TYPE_REFERENCE:'REFERENCE',FIELD_TYPE_BYTES:'BYTES',FIELD_TYPE_DOUBLE:'NUMBER_DOUBLE',FIELD_TYPE_INT64:'NUMBER_INT64',FIELD_TYPE_TIMESTAMP:'TIMESTAMP',FIELD_TYPE_FILTER:'FILTER',FIELD_TYPE_SHARE_PARTICIPANT:'SHARE_PARTICIPANT',COMPARATOR_EQUALS:'EQUALS',COMPARATOR_NOT_EQUALS:'NOT_EQUALS',COMPARATOR_LESS_THAN:'LESS_THAN',COMPARATOR_LESS_THAN_OR_EQUALS:'LESS_THAN_OR_EQUALS',COMPARATOR_GREATER_THAN:'GREATER_THAN',COMPARATOR_GREATER_THAN_OR_EQUALS:'GREATER_THAN_OR_EQUALS',COMPARATOR_NEAR:'NEAR',COMPARATOR_CONTAINS_ALL_TOKENS:'CONTAINS_ALL_TOKENS',COMPARATOR_IN:'IN',COMPARATOR_NOT_IN:'NOT_IN',COMPARATOR_CONTAINS_ANY_TOKENS:'CONTAINS_ANY_TOKENS',COMPARATOR_LIST_CONTAINS:'LIST_CONTAINS',COMPARATOR_NOT_LIST_CONTAINS:'NOT_LIST_CONTAINS',COMPARATOR_NOT_LIST_CONTAINS_ANY:'NOT_LIST_CONTAINS_ANY',COMPARATOR_BEGINS_WITH:'BEGINS_WITH',COMPARATOR_NOT_BEGINS_WITH:'NOT_BEGINS_WITH',COMPARATOR_LIST_MEMBER_BEGINS_WITH:'LIST_MEMBER_BEGINS_WITH',COMPARATOR_NOT_LIST_MEMBER_BEGINS_WITH:'NOT_LIST_MEMBER_BEGINS_WITH',COMPARATOR_LIST_CONTAINS_ALL:'LIST_CONTAINS_ALL',COMPARATOR_NOT_LIST_CONTAINS_ALL:'NOT_LIST_CONTAINS_ALL',SHARE_RECORD_TYPE_NAME:'cloudkit.share',DEFAULT_ZONE_NAME:'_defaultZone'};for(var key in constants){CKCatalog[key]=constants[key];}})();CKCatalog.FormInputHelpers.DEFAULT={valueKeys:{first:'value',last:'value'},add:function(opts){var name=opts.name;var value=opts.value;if(this.isNumberType(opts.type)){return this.addInputField({placeholder:'Field value',name:name+'-value',value:value});}
return this.addInputField({placeholder:opts.placeholder,name:name+'-value',type:opts.type,value:value});},toggle:function(opts,bool){this.toggleRow(opts.name+'-value',bool);return this;},remove:function(opts){var name=opts.name;this.removeRowByFieldName(name+'-value');delete this.fields[name+'-value'];return this;},serialize:function(opts){return this.getFieldValue(opts.name+'-value');}};CKCatalog.FormInputHelpers[CKCatalog.FIELD_TYPE_ASSET]={add:function(opts){return this.addFileInputField({name:opts.name+'-value',value:opts.value});},serialize:function(opts){var fileInput=this.fields[opts.name+'-value'];return fileInput.assetValue||fileInput.files[0];}};CKCatalog.FormInputHelpers[CKCatalog.FIELD_TYPE_BYTES]={add:function(opts){return this.addFileInputField({name:opts.name+'-value',value:opts.value,base64:true});},serialize:function(opts){var fileInput=this.fields[opts.name+'-value'];return fileInput.assetValue;}};CKCatalog.FormInputHelpers[CKCatalog.FIELD_TYPE_LOCATION]={valueKeys:{first:'latitude',last:'longitude'},add:function(opts){var name=opts.name;var value=opts.value;return this.addInputField({placeholder:'Latitude',name:name+'-latitude',value:value&&value.latitude}).addInputField({placeholder:'Longitude',name:name+'-longitude',value:value&&value.longitude});},toggle:function(opts,bool){this.toggleRow(opts.name+'-latitude',bool);return this;},remove:function(opts){var name=opts.name;this.removeRowByFieldName(name+'-longitude');delete this.fields[name+'-longitude'];delete this.fields[name+'-latitude'];return this;},serialize:function(opts){var lat=this.fields[opts.name+'-latitude'].value;var long=this.fields[opts.name+'-longitude'].value;if(isNaN(lat)||isNaN(long)){return null;}
return{latitude:parseFloat(lat),longitude:parseFloat(long)};}};CKCatalog.FormInputHelpers[CKCatalog.FIELD_TYPE_STRING]={add:function(opts){return this.addTextareaField({placeholder:'Field value',name:opts.name+'-value',value:opts.value});}};CKCatalog.FormInputHelpers[CKCatalog.FIELD_TYPE_REFERENCE]={valueKeys:{first:'record-name',last:'action'},add:function(opts){var name=opts.name;var value=opts.value;var classNames=opts.arrayItem?['array-item']:[];return this.addInputField({placeholder:'Record name',name:name+'-record-name',value:value&&value.recordName}).addMultipleFields({number:2,classNames:classNames}).addEmptyField().addInputField({placeholder:'Zone name',name:name+'-zone-name',value:value&&value.zoneID&&value.zoneID.zoneName}).addMultipleFields({number:2,classNames:classNames}).addEmptyField().addInputField({placeholder:'Owner record name',name:name+'-owner-record-name',value:value&&value.zoneID&&value.zoneID.ownerRecordName}).addMultipleFields({number:2,classNames:classNames}).addEmptyField().addSelectField({name:name+'-action',value:value&&value.action,options:[{value:'NONE',title:'No delete action'},{value:'DELETE_SELF'},{value:'VALIDATE'}]});},remove:function(opts){var name=opts.name;this.removeRowByFieldName(name+'-record-name').removeRowByFieldName(name+'-owner-record-name').removeRowByFieldName(name+'-action').removeRowByFieldName(name+'-zone-name');delete this.fields[name+'-record-name'];delete this.fields[name+'-owner-record-name'];delete this.fields[name+'-action'];delete this.fields[name+'-zone-name'];return this;},toggle:function(opts,bool){this.toggleRow(opts.name+'-record-name',bool);this.toggleRow(opts.name+'-zone-name',bool);this.toggleRow(opts.name+'-owner-record-name',bool);this.toggleRow(opts.name+'-action',bool);return this;},serialize:function(opts){var fields=this.fields;var recordName=fields[opts.name+'-record-name'].value;if(!recordName)return null;var reference={recordName:recordName,action:fields[opts.name+'-action'].value};var zoneName=fields[opts.name+'-zone-name'].value;if(zoneName){var zoneID={zoneName:fields[opts.name+'-zone-name'].value};var ownerRecordName=fields[opts.name+'-owner-record-name'].value;if(ownerRecordName){zoneID.ownerRecordName=ownerRecordName;}
reference.zoneID=zoneID;}
return reference;}};CKCatalog.FormInputHelpers[CKCatalog.FIELD_TYPE_SHARE_PARTICIPANT]={valueKeys:{first:'email',last:'permission'},add:function(opts){var name=opts.name;var value=opts.value;var classNames=opts.arrayItem?['array-item']:[];return this.addInputField({placeholder:'Email',type:'email',name:name+'-email',value:value&&value.userIdentity&&value.userIdentity.lookupInfo&&value.userIdentity.lookupInfo.emailAddress}).addMultipleFields({number:3,classNames:classNames}).addEmptyField().addLabel({label:'permission:',name:name+'-permission'}).addSelectField({name:name+'-permission',value:value&&value.permission,options:[{value:'NONE'},{value:'READ_ONLY'},{value:'READ_WRITE'}]}).addHiddenField({name:name+'-type',value:value&&value.type||CloudKit.ShareParticipantType.UNKNOWN}).addHiddenField({name:name+'-acceptance-status',value:value&&value.acceptanceStatus||CloudKit.ShareParticipantAcceptanceStatus.UNKNOWN});},remove:function(opts){var name=opts.name;this.removeRowByFieldName(name+'-email').removeRowByFieldName(name+'-permission').removeHiddenInputByFieldName(name+'-type').removeHiddenInputByFieldName(name+'-acceptance-status');delete this.fields[name+'-email'];delete this.fields[name+'-permission-label'];delete this.fields[name+'-permission'];delete this.fields[name+'-type'];delete this.fields[name+'-acceptance-status'];return this;},toggle:function(opts,bool){this.toggleRow(opts.name+'-email',bool);this.toggleRow(opts.name+'-permission',bool);return this;},serialize:function(opts){var fields=this.fields;var emailAddress=fields[opts.name+'-email'].value;if(!emailAddress)return null;return{emailAddress:emailAddress,permission:fields[opts.name+'-permission'].value,type:fields[opts.name+'-type'].value,acceptanceStatus:fields[opts.name+'-acceptance-status'].value};}};CKCatalog.FormInputHelpers[CKCatalog.FIELD_TYPE_TIMESTAMP]={add:function(opts){return this.addInputField({placeholder:'YYYY-MM-DDTHH:mm',name:opts.name+'-value',value:opts.value});},serialize:function(opts){var value=this.fields[opts.name+'-value'].value;if(!value)return value;if(isNaN(value)){var date=new Date(value);var time=date.getTime();if(isNaN(time)){return value;}
return time+date.getTimezoneOffset()*60000;}else{return parseInt(value);}}};CKCatalog.FormInputHelpers.Filters.DEFAULT={comparators:[CKCatalog.COMPARATOR_EQUALS,CKCatalog.COMPARATOR_NOT_EQUALS,CKCatalog.COMPARATOR_IN,CKCatalog.COMPARATOR_NOT_IN]};CKCatalog.FormInputHelpers.Filters[CKCatalog.FIELD_TYPE_LOCATION]={valueKeys:{last:'distance'},comparators:[CKCatalog.COMPARATOR_NEAR,CKCatalog.COMPARATOR_IN,CKCatalog.COMPARATOR_NOT_IN],add:function(opts){var name=opts.name;var that=this;var whenNearFilterSelected=function(bool){return function(){return(that.getFieldValue(name+'-comparator')===CKCatalog.COMPARATOR_NEAR)===bool;};};return this.addMultipleFields({number:2}).formHelperForType(CKCatalog.FIELD_TYPE_LOCATION).add(opts).addMultipleFields({number:2,hidden:whenNearFilterSelected(false),classNames:['filter','distance']}).addLabel({label:'Within',name:name+'-distance'}).addInputField({name:name+'-distance',placeholder:'Distance (m)'})},toggle:function(opts,bool){this.formHelperForType(CKCatalog.FIELD_TYPE_LOCATION).toggle(opts,bool);var showDistanceRow=false;var name=opts.name;if(bool===true){showDistanceRow=this.getFieldValue(name+'-comparator')===CKCatalog.COMPARATOR_NEAR;}
this.toggleRow(name+'-distance',showDistanceRow);return this;},remove:function(opts){this.formHelperForType(CKCatalog.FIELD_TYPE_LOCATION).remove(opts);var name=opts.name;this.removeRowByFieldName(name+'-distance');delete this.fields[name+'-distance-label'];delete this.fields[name+'-distance'];},serialize:function(opts){var name=opts.name;var distance=this.getFieldValue(name+'-distance');var comparator=this.getFieldValue(name+'-comparator');if(comparator===CKCatalog.COMPARATOR_NEAR){return{fieldValue:this.formHelperForType(CKCatalog.FIELD_TYPE_LOCATION).serialize(opts),distance:isNaN(distance)?0:parseFloat(distance)};}else{return this.formHelperForType(CKCatalog.FIELD_TYPE_LOCATION).serialize(opts);}}};CKCatalog.FormInputHelpers.Filters[CKCatalog.FIELD_TYPE_STRING]={comparators:[CKCatalog.COMPARATOR_EQUALS,CKCatalog.COMPARATOR_NOT_EQUALS,CKCatalog.COMPARATOR_CONTAINS_ALL_TOKENS,CKCatalog.COMPARATOR_CONTAINS_ANY_TOKENS,CKCatalog.COMPARATOR_BEGINS_WITH,CKCatalog.COMPARATOR_NOT_BEGINS_WITH,CKCatalog.COMPARATOR_IN,CKCatalog.COMPARATOR_NOT_IN]};CKCatalog.FormInputHelpers.Filters[CKCatalog.FIELD_TYPE_INT64]=CKCatalog.FormInputHelpers.Filters[CKCatalog.FIELD_TYPE_DOUBLE]=CKCatalog.FormInputHelpers.Filters[CKCatalog.FIELD_TYPE_TIMESTAMP]={comparators:[CKCatalog.COMPARATOR_EQUALS,CKCatalog.COMPARATOR_NOT_EQUALS,CKCatalog.COMPARATOR_LESS_THAN,CKCatalog.COMPARATOR_LESS_THAN_OR_EQUALS,CKCatalog.COMPARATOR_GREATER_THAN,CKCatalog.COMPARATOR_GREATER_THAN_OR_EQUALS,CKCatalog.COMPARATOR_IN,CKCatalog.COMPARATOR_NOT_IN],serialize:function(opts){return CKCatalog.FormInputHelpers[CKCatalog.FIELD_TYPE_TIMESTAMP].serialize.call(this,opts);}};CKCatalog.FormInputHelpers.Filters[CKCatalog.FIELD_TYPE_REFERENCE]={add:function(opts){var name=opts.name;return this.addInputField({placeholder:'Record name',name:name+'-record-name'}).addInputField({placeholder:'Zone name',name:name+'-zone-name'}).addInputField({placeholder:'Owner record name',name:name+'-owner-record-name'}).addSelectField({name:name+'-action',options:[{value:'NONE',title:'No delete action'},{value:'DELETE_SELF'},{value:'VALIDATE'}]});}};CKCatalog.Form=function Form(){this.el=document.createElement('form');this.el.setAttribute('action','#');this.el.setAttribute('method','post');this.el.id='f'+this.constructor.prototype._id++;this.el.className='form';this.table=this.el.appendChild(document.createElement('table'));var submitButton=document.createElement('input');submitButton.setAttribute('type','submit');submitButton.setAttribute('name','submit');submitButton.style.display='none';this.el.appendChild(submitButton);this.fields={};this.dynamicFieldNames={};this._multipleFields=0;this._multipleFieldsContainer=null;this._pointer=null;};CKCatalog.Form.prototype.formHelperForType=function(type){var helper=CKCatalog.FormInputHelpers[type]||{};var defaultHelper=CKCatalog.FormInputHelpers.DEFAULT;var that=this;return{valueKeys:{first:helper.valueKeys&&helper.valueKeys.first||defaultHelper.valueKeys.first,last:helper.valueKeys&&helper.valueKeys.last||defaultHelper.valueKeys.last},add:function(opts){var f=helper.add||defaultHelper.add;return f.call(that,opts);},remove:function(opts){var f=helper.remove||defaultHelper.remove;return f.call(that,opts);},toggle:function(opts,bool){var f=helper.toggle||defaultHelper.toggle;return f.call(that,opts,bool);},serialize:function(opts){var f=helper.serialize||defaultHelper.serialize;return f.call(that,opts);}};};CKCatalog.Form.prototype._id=0;CKCatalog.Form.prototype.addMultipleFields=function(opts){this._multipleFieldsContainer=this._createFieldContainer(opts);this._multipleFields=opts.number;return this;};CKCatalog.Form.prototype._insertRow=function(row){if(!this._pointer){this._pointer=this.table.appendChild(row);}else{this._pointer=this.table.insertBefore(row,this._pointer.nextSibling);}};CKCatalog.Form.prototype.focusField=function(name){var field=this.fields[name];if(field){field.focus();}
return this;};CKCatalog.Form.prototype._createRelativeId=function(name){return this.el.id+'-'+name;};CKCatalog.Form.prototype._createFieldContainer=function(opts){opts=opts||{};if(this._multipleFields){this._multipleFields--;return this._multipleFieldsContainer;}
var tr=document.createElement('tr');tr.className='field';if(opts.hidden){if(typeof opts.hidden==='function'){if(opts.hidden.call(this)){tr.classList.add('hide');}}else{tr.classList.add('hide');}}
if(opts.number){tr.classList.add('multiple');tr.classList.add('has-'+opts.number+'-fields');}
if(Array.isArray(opts.classNames)){opts.classNames.forEach(function(className){tr.classList.add(className);});}
var labelContainer=document.createElement('th');if(opts.label){var label=document.createElement('label');label.textContent=opts.label;if(opts.name){label.setAttribute('for',this._createRelativeId(opts.name));}
labelContainer.appendChild(label);}
tr.appendChild(labelContainer);var td=document.createElement('td');tr.appendChild(td);var removeButtonContainer=document.createElement('td');removeButtonContainer.className='remove-button-cell';if(opts.removeButtonAction){var button=document.createElement('button');button.className='link small';button.innerHTML='&#10005;';button.setAttribute('tabindex','-1');button.setAttribute('type','button');var that=this;button.onclick=function(){opts.removeButtonAction.call(that,opts);};removeButtonContainer.appendChild(button);}
tr.appendChild(removeButtonContainer);return td;};CKCatalog.Form.prototype.addInputField=function(opts){var fieldContainer=this._createFieldContainer(opts);var borderContainer=document.createElement('div');if(Array.isArray(opts.classNames)){opts.classNames.forEach(function(className){borderContainer.classList.add(className);});}
var inputContainer=document.createElement('div');inputContainer.className='border';var input=document.createElement('input');input.setAttribute('type',opts.type||'text');input.setAttribute('name',opts.name);if(opts.placeholder){input.setAttribute('placeholder',opts.placeholder);}
input.id=this._createRelativeId(opts.name);if(opts.value!==undefined){input.value=opts.value;}
if(opts.onChange){input.onValueChange=opts.onChange;input.addEventListener('input',opts.onChange.bind(this));}
this.fields[opts.name]=input;inputContainer.appendChild(input);borderContainer.appendChild(inputContainer);fieldContainer.appendChild(borderContainer);this._insertRow(fieldContainer.parentNode);return this;};CKCatalog.Form.prototype.setFieldValue=function(key,value){var field=this.fields[key];var oldValue;if(field){if(typeof value=='boolean'){oldValue=field.checked;field.checked=value;if(oldValue!==value&&field.onValueChange){field.onValueChange.call(this);}}else{oldValue=field.value;field.value=value;if(oldValue!==value&&field.onValueChange){field.onValueChange.call(this);}}}else if(Array.isArray(value)){var dynamicFieldName=this.dynamicFieldNames[key];if(dynamicFieldName&&dynamicFieldName.arrayField){this._addArrayItems(value,{name:key,type:dynamicFieldName.arrayField});}}else if(typeof value=='object'){this._addDynamicFieldsFromFieldsMap(key,value);}};CKCatalog.Form.prototype.getFieldValue=function(key){var field=this.fields[key];if(field){if(field.type=='checkbox'){return field.checked;}else{return field.value;}}else{return this._serializeDynamicFields(key);}};CKCatalog.Form.prototype.addTextareaField=function(opts){opts.classNames=opts.classNames||[];var borderContainer=document.createElement('div');opts.classNames.forEach(function(className){borderContainer.classList.add(className);});borderContainer.classList.add('textarea-border-container');var fieldContainer=this._createFieldContainer(opts);var inputContainer=document.createElement('div');inputContainer.className='border textarea-container';var input=document.createElement('textarea');input.setAttribute('spellcheck','false');input.setAttribute('name',opts.name);if(opts.placeholder){input.setAttribute('placeholder',opts.placeholder);}
if(opts.value){input.value=opts.value;}
input.id=this._createRelativeId(opts.name);this.fields[opts.name]=input;inputContainer.appendChild(input);borderContainer.appendChild(inputContainer);fieldContainer.appendChild(borderContainer);this._insertRow(fieldContainer.parentNode);return this;};CKCatalog.Form.prototype.addFileInputField=function(opts){var fieldContainer=this._createFieldContainer(opts);var borderContainer=document.createElement('div');var inputContainer=document.createElement('div');inputContainer.className='border';var input=document.createElement('input');input.setAttribute('type','file');input.setAttribute('name',opts.name);input.id=this._createRelativeId(opts.name);var fakeInput=document.createElement('div');fakeInput.className='fake-file-input';var selectFileButton=document.createElement('button');selectFileButton.className='link';var setFileButtonText=function(hasFile){hasFile?selectFileButton.textContent='Replace…':selectFileButton.textContent='Choose file…';};var span=document.createElement('span');span.className='file-name';input.addEventListener('change',function(){var file=input.files[0];if(file){span.textContent=CKCatalog.renderUtils.abbreviateSIUnits(file.size,2,'B');if(opts.base64){var fileReader=new FileReader();CKCatalog.dialog.show('Converting to base64…');fileReader.onload=function(evt){var base64=evt.target.result;base64=base64.substr(base64.indexOf(';base64,')+8);input.assetValue=base64;CKCatalog.dialog.hide();};fileReader.onerror=function(error){CKCatalog.dialog.showError(error);};fileReader.readAsDataURL(file);}else{input.assetValue=null;}}else{span.textContent='';}
setFileButtonText(file);});if(opts.value){input.assetValue=opts.value;var size=opts.value.size||atob(opts.value).length;span.textContent=CKCatalog.renderUtils.abbreviateSIUnits(size,2,'B');}
setFileButtonText(opts.value);fakeInput.appendChild(selectFileButton);fakeInput.appendChild(span);inputContainer.appendChild(fakeInput);inputContainer.appendChild(input);borderContainer.appendChild(inputContainer);fieldContainer.appendChild(borderContainer);this.fields[opts.name]=input;this._insertRow(fieldContainer.parentNode);return this;};CKCatalog.Form.prototype.addSelectField=function(opts){var fieldContainer=this._createFieldContainer(opts);var borderContainer=document.createElement('div');var selectContainer=document.createElement('div');selectContainer.className='border select';var select=document.createElement('select');select.setAttribute('name',opts.name);select.id=this._createRelativeId(opts.name);opts.options.forEach(function(opt){var option=document.createElement('option');option.textContent=opt.title||opt.value;if(opt.value){option.setAttribute('value',opt.value);}
if(opt.selected){option.setAttribute('selected','');}
select.appendChild(option);});this.fields[opts.name]=select;if(opts.value){select.value=opts.value;}
if(opts.onChange){select.onValueChange=opts.onChange;select.addEventListener('change',opts.onChange.bind(this));}
selectContainer.appendChild(select);borderContainer.appendChild(selectContainer);fieldContainer.appendChild(borderContainer);this._insertRow(fieldContainer.parentNode);return this;};CKCatalog.Form.prototype.addEmptyField=function(){var fieldContainer=this._createFieldContainer();var emptyField=document.createElement('div');emptyField.className='empty';fieldContainer.appendChild(emptyField);this._insertRow(fieldContainer.parentNode);return this;};CKCatalog.Form.prototype.addHiddenField=function(opts){var input=document.createElement('input');input.style.display='none';input.setAttribute('name',opts.name);input.value=opts.value;if(opts.onChange){input.onValueChange=opts.onChange;}
this.fields[opts.name]=input;this.el.appendChild(input);return this;};CKCatalog.Form.prototype.addLabel=function(opts){var fieldContainer=this._createFieldContainer();var container=document.createElement('div');var labelContainer=document.createElement('div');labelContainer.className='label';var label=document.createElement('label');label.setAttribute('for',this._createRelativeId(opts.name));label.textContent=opts.label;labelContainer.appendChild(label);container.appendChild(labelContainer);fieldContainer.appendChild(container);this._insertRow(fieldContainer.parentNode);this.fields[opts.name+'-label']=label;return this;};CKCatalog.Form.prototype.addCheckboxes=function(opts){var fieldContainer=this._createFieldContainer(opts);var checkboxesContainer=document.createElement('div');checkboxesContainer.className='checkboxes';var fields=this.fields;var that=this;opts.checkboxes.forEach(function(checkbox){var checkboxContainer=document.createElement('div');checkboxContainer.className='checkbox';if(checkbox.label){var label=document.createElement('label');label.setAttribute('for',that._createRelativeId(checkbox.name));label.textContent=checkbox.label;checkboxContainer.appendChild(label);}
var input=document.createElement('input');input.setAttribute('type','checkbox');input.setAttribute('name',checkbox.name);if(checkbox.value){input.setAttribute('value',checkbox.value);}
input.id=that._createRelativeId(checkbox.name);if(checkbox.checked){input.setAttribute('checked','');}
fields[checkbox.name]=input;checkboxContainer.appendChild(input);checkboxesContainer.appendChild(checkboxContainer);});fieldContainer.appendChild(checkboxesContainer);this._insertRow(fieldContainer.parentNode);return this;};CKCatalog.Form.prototype.onSubmit=function(handler){this.el.onsubmit=function(e){e.preventDefault();handler();};};CKCatalog.Form.prototype.getFieldRowForFieldName=function(fieldName){var field=this.fields[fieldName];if(field){var el=field;while(el.parentNode){el=el.parentNode;if(el.classList.contains('field')){return el;}}}
return null;};CKCatalog.Form.prototype.addButton=function(opts){var container=this._createFieldContainer(opts);var borderContainer=document.createElement('div');if(Array.isArray(opts.classNames)){opts.classNames.forEach(function(className){borderContainer.classList.add(className);});}
var buttonContainer=document.createElement('div');buttonContainer.className='form-button'+
(opts.border?' border':'');var button=document.createElement('button');button.setAttribute('type','button');button.className='link';button.textContent=opts.title;button.id=this._createRelativeId(opts.name);button.addEventListener('click',opts.action);this.fields[opts.name]=button;buttonContainer.appendChild(button);borderContainer.appendChild(buttonContainer);container.appendChild(borderContainer);this._insertRow(container.parentNode);return this;};CKCatalog.Form.prototype.movePointerTo=function(name){this._pointer=this.getFieldRowForFieldName(name);return this;};CKCatalog.Form.prototype.resetPointer=function(){this._pointer=null;return this;};CKCatalog.Form.prototype.createDynamicFieldName=function(name,index){return name+'-'+index;};CKCatalog.Form.prototype.addDynamicFields=function(opts){var dynamicFieldsIndex=0;var that=this;var addField=function(){dynamicFieldsIndex++;that.movePointerTo(opts.name+'-field-type-selector')._addDynamicField({name:that.createDynamicFieldName(opts.name,dynamicFieldsIndex),type:that.fields[opts.name+'-field-type-selector'].value,list:that.fields[opts.name+'-list-checkbox'].checked});};return this.addMultipleFields({number:3,label:opts.label}).addSelectField({name:opts.name+'-field-type-selector',label:'Field type:',options:[{value:CKCatalog.FIELD_TYPE_STRING,title:'String'},{value:CKCatalog.FIELD_TYPE_INT64,title:'Number'},{value:CKCatalog.FIELD_TYPE_TIMESTAMP,title:'Timestamp'},{value:CKCatalog.FIELD_TYPE_LOCATION,title:'Location'},{value:CKCatalog.FIELD_TYPE_ASSET,title:'Asset'},{value:CKCatalog.FIELD_TYPE_BYTES,title:'Bytes'},{value:CKCatalog.FIELD_TYPE_REFERENCE,title:'Reference'}]}).addCheckboxes({checkboxes:[{label:'list',name:opts.name+'-list-checkbox'}]}).addButton({name:opts.name+'-add-field-button',title:'Add field…',action:addField});};CKCatalog.Form.prototype._getValueKey=function(opts){var position=opts.position||'first';return opts.name+'-'+this.formHelperForType(opts.type).valueKeys[position];};CKCatalog.Form.prototype._addFieldValueForType=function(opts){return this.formHelperForType(opts.type).add(opts);};CKCatalog.Form.prototype.isNumberType=function(type){return /NUMBER/.test(type)||type===CKCatalog.FIELD_TYPE_TIMESTAMP;};CKCatalog.Form.prototype.addArrayField=function(opts){return this._addDynamicField({name:opts.name,list:true,arrayField:opts.type,label:opts.label,hidden:opts.hidden,type:opts.type,placeholder:opts.placeholder,buttonTitle:opts.buttonTitle});};CKCatalog.Form.prototype.toggleRow=function(fieldName,bool){var row=this.getFieldRowForFieldName(fieldName);if(row){if(bool){row.classList.remove('hide');}else{row.classList.add('hide');}}};CKCatalog.Form.prototype.toggleArrayField=function(name,bool){this.toggleRow(name+'-add-item',bool);this.toggleArrayItems(name,bool);};CKCatalog.Form.prototype.toggleArrayItems=function(name,bool){var arrayFieldName=this.dynamicFieldNames[name];if(arrayFieldName&&Array.isArray(arrayFieldName.value)){var that=this;arrayFieldName.value.forEach(function(arrayValue){that._toggleDynamicField(arrayValue,bool);});}};CKCatalog.Form.prototype._toggleDynamicField=function(opts,bool){this.formHelperForType(opts.type).toggle(opts,bool);};CKCatalog.Form.prototype.removeRowByFieldName=function(name){try{this.table.removeChild(this.getFieldRowForFieldName(name));}catch(e){}
return this;};CKCatalog.Form.prototype.removeHiddenInputByFieldName=function(name){try{this.el.removeChild(this.fields[name]);}catch(e){}
return this;};CKCatalog.Form.prototype._removeFieldValue=function(value){if(Array.isArray(value)){var that=this;value.forEach(function(item){that.removeArrayItem(item);});}else{this.formHelperForType(value.type).remove(value);}
return this;};CKCatalog.Form.prototype._removeFieldKey=function(opts){var name=opts.key;this.removeRowByFieldName(name+'-key');delete this.fields[name+'-key'];delete this.dynamicFieldNames[name];if(!opts.arrayField){delete this.fields[name+'-add-item'];}else{this.dynamicFieldNames[name]={key:opts.key,value:[],arrayField:opts.arrayField};}
return this;};CKCatalog.Form.prototype._removeLabel=function(opts){delete this.fields[this._getValueKey({type:opts.type,name:opts.name,position:'first'})+'-label'];return this;};CKCatalog.Form.prototype.removeArrayItem=function(opts){return this._removeFieldValue(opts)._removeLabel(opts);};CKCatalog.Form.prototype._removeDynamicField=function(opts){return this._removeFieldValue(opts.value)._removeFieldKey(opts);};CKCatalog.Form.prototype.addArrayItem=function(opts){var number=opts.type===CKCatalog.FIELD_TYPE_LOCATION?3:2;if(!this.dynamicFieldNames[opts.name]){this.dynamicFieldNames[opts.name]={key:opts.name,value:[],arrayField:opts.arrayField};}
var types=this.dynamicFieldNames[opts.name].value;var buttonRelativeName='-'+(opts.buttonRelativeName||'add-item');var button=this.fields[opts.name+buttonRelativeName];var index=button.arrayItemIndex||0;var indexedName=this.createDynamicFieldName(opts.name,index);button.arrayItemIndex=index+1;var that=this;var value={type:opts.type,name:indexedName};types.push(value);return this.movePointerTo(types.length>1?this._getValueKey({name:types[types.length-2].name,position:'last',type:opts.type}):opts.name+buttonRelativeName).addMultipleFields({number:number,classNames:['array-item'],removeButtonAction:function(){var typeIndex=types.reduce(function(n,t,i){if(t.name===indexedName){return i;}else{return n;}},-1);if(typeIndex>-1){types.splice(typeIndex,1);}
that.removeArrayItem(value);types.forEach(function(t,i){var label=that.fields[that._getValueKey({type:t.type,name:t.name,position:'first'})+'-label'];label.textContent=i;});}}).addLabel({label:(types.length-1).toString(),name:that._getValueKey({type:opts.type,name:indexedName,position:'first'})})._addFieldValueForType({name:indexedName,type:opts.type,arrayItem:true,value:opts.value,placeholder:opts.placeholder}).focusField(that._getValueKey({type:opts.type,name:indexedName,position:'first'}));};CKCatalog.Form.prototype._addDynamicField=function(opts){var that=this;var number=opts.type===CKCatalog.FIELD_TYPE_LOCATION?3:2;var dynamicFieldDatum;if(opts.list){var types=[];dynamicFieldDatum={key:opts.name,value:types};this.dynamicFieldNames[opts.name]=dynamicFieldDatum;if(!opts.arrayField){this.addMultipleFields({number:2,removeButtonAction:function(){that._removeDynamicField(dynamicFieldDatum);}}).addInputField({placeholder:'Field name',name:opts.name+'-key',value:opts.key}).focusField(opts.name+'-key');}else{dynamicFieldDatum.arrayField=opts.type;}
return this.addButton({title:opts.buttonTitle||'Add item…',name:opts.name+'-add-item',border:true,hidden:opts.hidden,label:opts.label,action:function(){that.addArrayItem(opts);}})}else{dynamicFieldDatum={value:{type:opts.type,name:opts.name},key:opts.name};this.dynamicFieldNames[opts.name]=dynamicFieldDatum;return this.addMultipleFields({number:number,removeButtonAction:function(){that._removeDynamicField(dynamicFieldDatum);}}).addInputField({placeholder:'Field name',name:opts.name+'-key',value:opts.key})._addFieldValueForType(opts).focusField(opts.name+'-key');}};CKCatalog.Form.prototype._removeDynamicFields=function(){for(var key in this.dynamicFieldNames){this._removeDynamicField(this.dynamicFieldNames[key]);}};CKCatalog.Form.prototype.reset=function(){this.el.reset();this._removeDynamicFields();return this;};CKCatalog.Form.prototype._addDynamicFieldsFromFieldsMap=function(name,fieldsMap){var dynamicFieldsIndex=0;this.movePointerTo(name+'-add-field-button');for(var key in fieldsMap){if(fieldsMap.hasOwnProperty(key)){var field=fieldsMap[key];var value=field.value;var type=field.type;var arrayName=this.createDynamicFieldName(name,dynamicFieldsIndex++);type=type.replace('INT64_LIST','NUMBER_INT64');type=type.replace('DOUBLE_LIST','NUMBER_DOUBLE');type=type.replace('_LIST','');var that=this;if(Array.isArray(value)){this._addDynamicField({name:arrayName,list:true,key:key,type:type});value.forEach(function(v){that.addArrayItem({name:arrayName,type:type,value:v})});}else{this._addDynamicField({name:arrayName,type:type,value:value,key:key});}}}
return this;};CKCatalog.Form.prototype._addArrayItems=function(array,opts){if(Array.isArray(array)){var that=this;array.forEach(function(value){that.addArrayItem({value:value,name:opts.name,type:opts.type,arrayField:opts.type});});}};CKCatalog.Form.prototype._getValueFromTypedField=function(opts){return this.formHelperForType(opts.type).serialize(opts);};CKCatalog.Form.prototype._serializeDynamicFields=function(prefix){var object={};if(!prefix)return object;var dict=this.dynamicFieldNames[prefix];if(dict&&Array.isArray(dict.value)){if(dict.arrayField){return dict.value.map(this._getValueFromTypedField.bind(this)).filter(function(v){return v!==null;});}
if(dict.queryBuilder){return this._serializeFilters(dict);}}
var fields=this.fields;for(var key in this.dynamicFieldNames){if(key.substr(0,prefix.length)===prefix&&(key[prefix.length]===undefined||key[prefix.length]==='-')){var datum=this.dynamicFieldNames[key];var keyField=fields[datum.key+'-key'];var fieldName=keyField&&keyField.value||!keyField&&key;if(fieldName){if(Array.isArray(datum.value)){object[fieldName]=datum.value.map(this._getValueFromTypedField.bind(this)).filter(function(v){return v!==null;});}else{object[fieldName]=this._getValueFromTypedField(datum.value);}}}}
return object;};CKCatalog.renderUtils=(function(){var renderRecords=function(table,title,records,displayFields){var content=document.createElement('div');if(title){var heading=document.createElement('h2');heading.textContent=title;content.appendChild(heading);}
if(records.length===0){table.appendRow([]);}else{records.forEach(function(record){table.appendRow(displayFields.map(function(fieldName){var fields=fieldName.match(/^fields\.(.*)/);if(fields&&record.hasOwnProperty('fields')&&typeof record.fields=='object'){var field=record.fields[fields[1]];if(field){return field.value;}}else if(fieldName==='created'||fieldName==='modified'){var value=record[fieldName];if(value){return{userRecordName:value&&value.userRecordName,timestamp:value&&new Date(value.timestamp),deviceID:value&&value.deviceID};}}else{return record[fieldName];}}));});}
content.appendChild(table.el);return content;};var renderRecord=function(title,record){var content=document.createElement('div');if(title){var heading=document.createElement('h2');heading.textContent=title;content.appendChild(heading);}
var table=(new CKCatalog.Table).setTextForUndefinedValue('None');var specialFields=['created','modified','fields','share','rootRecord'];['created','modified'].forEach(function(key){var value=record[key];if(value){table.appendRow(key,{userRecordName:value&&value.userRecordName,timestamp:value&&new Date(value.timestamp),deviceID:value&&value.deviceID});}});Object.keys(record).forEach(function(key){if(specialFields.indexOf(key)<0||key==='share'&&!record.share.participants){table.appendRow(key,record[key]);}});if(record.hasOwnProperty('fields')&&typeof record.fields=='object'){Object.keys(record.fields).forEach(function(fieldName){var field=record.fields[fieldName];if(field){table.appendRow(fieldName,field.value,{type:field.type.replace('_LIST','')});}});}
content.appendChild(table.el);return content;};var abbreviateSIUnits=function(number,precision,unit){var kilo=1e3;var mega=1e6;var giga=1e9;var tera=1e12;var peta=1e15;var multiplier=Math.pow(10,precision);var round=function(x){return Math.round(x*multiplier)/multiplier;};if(number>=peta){return round(number/peta)+' P'+unit;}else if(number>=tera){return round(number/tera)+' T'+unit;}else if(number>=giga){return round(number/giga)+' G'+unit;}else if(number>=mega){return round(number/mega)+' M'+unit;}else if(number>=kilo){return round(number/kilo)+' K'+unit;}else{return round(number)+unit;}};return{renderRecord:renderRecord,renderRecords:renderRecords,abbreviateSIUnits:abbreviateSIUnits};})();CKCatalog.QueryString=(function(){var qs=window.location.search.substr(1).split('&').reduce(function(previousValue,currentValue){var kv=currentValue.split('=');previousValue[kv[0]]=kv[1]?decodeURIComponent(kv[1]):true;return previousValue;},{});var getParameterByName=function(name){return qs[name];};return{getParameterByName:getParameterByName};})();CKCatalog.Form.prototype._getFilterHelperForType=function(name,type,isList){var helper=CKCatalog.FormInputHelpers.Filters[type]||{};var defaultHelper={};for(var key in CKCatalog.FormInputHelpers.DEFAULT){if(!defaultHelper.hasOwnProperty(key)){defaultHelper[key]=CKCatalog.FormInputHelpers.Filters.DEFAULT[key]||CKCatalog.FormInputHelpers[type]&&CKCatalog.FormInputHelpers[type][key]||CKCatalog.FormInputHelpers.DEFAULT[key];}}
var toggleHelper=helper.toggle||defaultHelper.toggle;var addHelper=helper.add||defaultHelper.add;var removeHelper=helper.remove||defaultHelper.remove;var serializeHelper=helper.serialize||defaultHelper.serialize;var that=this;var removeArrayItems=function(indexedName){var arrayItems=that.dynamicFieldNames[indexedName];if(arrayItems&&Array.isArray(arrayItems.value)){arrayItems.value.forEach(function(dynamicFieldReference){that.removeArrayItem(dynamicFieldReference);});}
delete that.dynamicFieldNames[indexedName];};var remove=function(opts){var indexedName=opts.name;that.removeRowByFieldName(indexedName+'-field-name');that.removeRowByFieldName(indexedName+'-add-value-button');delete that.fields[indexedName+'-field-name'];delete that.fields[indexedName+'-comparator'];delete that.fields[indexedName+'-add-value-button'];removeHelper.call(that,opts);removeArrayItems(indexedName);var arrayOfValues=that.dynamicFieldNames[name]&&that.dynamicFieldNames[name].value;if(arrayOfValues&&Array.isArray(arrayOfValues)){var arrayIndex=arrayOfValues.reduce(function(n,currentValue,i){if(currentValue.name===indexedName){return i;}else{return n;}},-1);if(arrayIndex>-1){arrayOfValues.splice(arrayIndex,1);}}};return{valueKeys:{first:'field-name',last:helper.valueKeys&&helper.valueKeys.last||defaultHelper.valueKeys.last},add:function(opts){var indexedName=opts.name;var fieldNamesArray=that.dynamicFieldNames[name].value;fieldNamesArray.unshift({type:type,name:indexedName});var whenComparatorRequiresListValues=function(bool){return function(){return that._comparatorRequiresListValues(that.getFieldValue(indexedName+'-comparator'))==bool;};};var toggleAddValueButton=function(){var comparatorRequiresListValues=whenComparatorRequiresListValues(true)();toggleHelper.call(that,opts,!comparatorRequiresListValues);that.toggleRow(indexedName+'-add-value-button',comparatorRequiresListValues);if(!comparatorRequiresListValues){removeArrayItems(indexedName);}};that.addMultipleFields({number:2,removeButtonAction:function(){remove({name:indexedName});}}).addInputField({name:indexedName+'-field-name',placeholder:'Field name'}).addSelectField({name:indexedName+'-comparator',options:(isList&&that._comparatorsForListField||helper.comparators||CKCatalog.FormInputHelpers.Filters.DEFAULT.comparators).map(function(comparator){return{value:comparator};}),onChange:toggleAddValueButton});addHelper.call(that,opts);that.addButton({title:'Add value…',border:true,hidden:whenComparatorRequiresListValues(false),action:function(){that.addArrayItem({name:indexedName,type:type,placeholder:'List value',buttonRelativeName:'add-value-button'});},name:indexedName+'-add-value-button'});return that;},remove:remove,toggle:function(opts,bool){var name=opts.name;var comparator=that.getFieldValue(name+'-comparator');that.toggleRow(name+'-field-name',bool);if(bool===true){toggleHelper.call(that,opts,!that._comparatorRequiresListValues(comparator));that.toggleRow(name+'-add-value-button',that._comparatorRequiresListValues(comparator));}else{toggleHelper.call(that,opts,bool);that.toggleRow(name+'-add-value-button',bool);}
that.toggleArrayItems(name,bool);},serialize:function(opts){var name=opts.name;var comparator=that.fields[name+'-comparator'].value;var dynamicFieldNames=that.dynamicFieldNames[name];var fieldName=that.fields[name+'-field-name'].value;var json={comparator:comparator};if(fieldName){json.fieldName=fieldName;}
if(that._comparatorRequiresListValues(comparator)){json.fieldValue=dynamicFieldNames.value&&dynamicFieldNames.value.map(function(dynamicFieldReference){return that.formHelperForType(dynamicFieldReference.type).serialize(dynamicFieldReference);});}else if(comparator===CKCatalog.COMPARATOR_NEAR){var serializedLocation=serializeHelper.call(that,opts);json.fieldValue=serializedLocation.fieldValue;json.distance=serializedLocation.distance;}else{json.fieldValue=serializeHelper.call(that,opts);}
return json;}};};CKCatalog.Form.prototype._comparatorRequiresListValues=function(comparator){return[CKCatalog.COMPARATOR_IN,CKCatalog.COMPARATOR_NOT_IN,CKCatalog.COMPARATOR_LIST_CONTAINS_ALL,CKCatalog.COMPARATOR_NOT_LIST_CONTAINS_ALL,CKCatalog.COMPARATOR_NOT_LIST_CONTAINS_ANY].indexOf(comparator)>-1;};CKCatalog.Form.prototype._comparatorsForListField=[CKCatalog.COMPARATOR_LIST_CONTAINS,CKCatalog.COMPARATOR_NOT_LIST_CONTAINS,CKCatalog.COMPARATOR_LIST_CONTAINS_ALL,CKCatalog.COMPARATOR_NOT_LIST_CONTAINS_ANY,CKCatalog.COMPARATOR_NOT_LIST_CONTAINS_ALL,CKCatalog.COMPARATOR_LIST_MEMBER_BEGINS_WITH,CKCatalog.COMPARATOR_NOT_LIST_MEMBER_BEGINS_WITH];CKCatalog.Form.prototype.addQueryBuilder=function(opts){var name=opts.name;this.dynamicFieldNames[name]={key:name,value:[],queryBuilder:true};var that=this;return this.addMultipleFields({number:3,label:opts.label,hidden:opts.hidden}).addSelectField({name:name+'-field-type-selector',label:'Field type:',options:[{value:CKCatalog.FIELD_TYPE_STRING,title:'String'},{value:CKCatalog.FIELD_TYPE_INT64,title:'Number'},{value:CKCatalog.FIELD_TYPE_TIMESTAMP,title:'Timestamp'},{value:CKCatalog.FIELD_TYPE_LOCATION,title:'Location'},{value:CKCatalog.FIELD_TYPE_REFERENCE,title:'Reference'}]}).addCheckboxes({checkboxes:[{label:'list',name:name+'-list-checkbox'}]}).addButton({name:name+'-add-filter-button',title:'Add filter…',action:function(){var isList=that.getFieldValue(name+'-list-checkbox');var fieldType=that.getFieldValue(name+'-field-type-selector');var button=that.fields[name+'-add-filter-button'];var index=button.arrayItemIndex||0;var indexedName=that.createDynamicFieldName(name,index);button.arrayItemIndex=index+1;var helper=that._getFilterHelperForType(name,fieldType,isList);that.movePointerTo(name+'-add-filter-button');helper.add({name:indexedName,type:fieldType});that.focusField(indexedName+'-'+helper.valueKeys.first);}});};CKCatalog.Form.prototype._serializeFilters=function(filters){var that=this;return filters.value.map(function(filter){return that._getFilterHelperForType(filters.key,filter.type).serialize(filter);});};CKCatalog.Form.prototype.toggleFilters=function(name,bool){var filters=this.dynamicFieldNames[name];var that=this;if(filters&&filters.queryBuilder){if(Array.isArray(filters.value)){filters.value.forEach(function(filter){that._getFilterHelperForType(filters.key,filter.type).toggle({name:filter.name},bool);});}}
this.toggleRow(name+'-add-filter-button',bool);};/*
<samplecode>
  <abstract>
    The authentication sample code with some helper functions to render the username/user record name and to construct
    the auth button containers.
  </abstract>
</samplecode>
*/
CKCatalog.tabs['authentication'] = (function() {

  var displayUserName = function(name) {
    var userNameEl = document.getElementById('username');
    userNameEl.textContent = name;
    var displayedUserName = document.getElementById('displayed-username');
    if(displayedUserName) {
      displayedUserName.textContent = name;
    }
  };

  var createButtonContainersHTML = function() {
    return '<div>'+
      '<h2 id="displayed-username"></h2>'+
        '<div style="width: 280px;">'+
          '<div id="apple-sign-in-button"></div>'+
          '<div id="apple-sign-out-button"></div>'+
        '</div>'+
    '</div>';
  };

  var showDialogForPersistError = function() {
    var html = '<h2>Unable to set a cookie</h2><p>';

    if(window.location.protocol === 'file:') {
      html += 'The authentication option <code>persist = true</code> is not compatible with the <i>file://</i> protocol. ';
    }

    html += 'Please edit <i>js/configure.js</i> and set <code>persist = false</code> in <i>CloudKit.configure()</i>.</p>';

    CKCatalog.dialog.show(html, { title: 'Close' });
  };

  var authSample = {
    run: function() {
      var content = this.content;
      content.innerHTML = createButtonContainersHTML();
      return this.sampleCode().then(function() {
        return content.firstChild;
      });
    },
    sampleCode: function demoSetUpAuth() {

      // Get the container.
      var container = CloudKit.getDefaultContainer();

      function gotoAuthenticatedState(userIdentity) {
        var name = userIdentity.nameComponents;
        if(name) {
          displayUserName(name.givenName + ' ' + name.familyName);
        } else {
          displayUserName('User record name: ' + userIdentity.userRecordName);
        }
        container
          .whenUserSignsOut()
          .then(gotoUnauthenticatedState);
      }
      function gotoUnauthenticatedState(error) {

        if(error && error.ckErrorCode === 'AUTH_PERSIST_ERROR') {
          showDialogForPersistError();
        }

        displayUserName('Unauthenticated User');
        container
          .whenUserSignsIn()
          .then(gotoAuthenticatedState)
          .catch(gotoUnauthenticatedState);
      }

      // Check a user is signed in and render the appropriate button.
      return container.setUpAuth()
        .then(function(userIdentity) {

          // Either a sign-in or a sign-out button was added to the DOM.

          // userIdentity is the signed-in user or null.
          if(userIdentity) {
            gotoAuthenticatedState(userIdentity);
          } else {
            gotoUnauthenticatedState();
          }
        });
    }
  };

  return [ authSample ];

})();/*
<samplecode>
  <abstract>
    The discoverability sample code with some helper functions to render the userIdentity inside a table and some forms
    to accept user input.
  </abstract>
</samplecode>
*/
CKCatalog.tabs['discoverability'] = (function() {


  var renderUserIdentity = function(title,userIdentity) {

    // Add the user id to the recordName input form for convenience.
    if(userIdentity.userRecordName) {
      recordNameInputForm.fields['record-name'].value = userIdentity.userRecordName;
    }

    // Now render the object.
    return CKCatalog.renderUtils.renderRecord(title,userIdentity);
  };

  var createUserIdentitiesTable = function() {
    return new CKCatalog.Table([
      'userRecordName', 'nameComponents', 'lookupInfo'
    ]).setTextForUndefinedValue('PRIVATE')
      .setTextForEmptyRow('No discovered users');
  };

  var renderUserIdentities = function(title,userIdentities) {
    var table = createUserIdentitiesTable();
    return CKCatalog.renderUtils.renderRecords(table,title,userIdentities,
      ['userRecordName','nameComponents','lookupInfo']
    );
  };

  var emailInputForm = (new CKCatalog.Form)
    .addInputField({
      type: 'email',
      placeholder: 'Email address',
      name: 'email',
      label: 'emailAddress:',
      value: 'my_discoverable_user@icloud.com'
    });

  var recordNameInputForm = (new CKCatalog.Form)
    .addInputField({
      placeholder: 'User record name',
      name: 'record-name',
      label: 'userRecordName:'
    });


  var fetchUserIdentitySample = {
    title: 'fetchCurrentUserIdentity',
    sampleCode: function demoFetchCurrentUserIdentity() {
      var container = CloudKit.getDefaultContainer();

      // Fetch user's info.
      return container.fetchCurrentUserIdentity()
        .then(function(userIdentity) {
          var title = 'UserIdentity for current '+
            (userIdentity.nameComponents ? 'discoverable' : 'non-discoverable')+
            ' user:';

          // Render the user's identity.
          return renderUserIdentity(title,userIdentity);
        });
    }

  };

  var discoverAllUserIdentitiesSample = {
    title: 'discoverAllUserIdentities',
    sampleCode: function demoDiscoverAllUserIdentities() {
      var container = CloudKit.getDefaultContainer();

      return container.discoverAllUserIdentities().then(function(response) {
        if(response.hasErrors) {

          // Handle the errors in your app.
          throw response.errors[0];

        } else {
          var title = 'Discovered users from your iCloud contacts:';

          // response.users is an array of UserIdentity objects.
          return renderUserIdentities(title, response.users);

        }
      });
    }
  };

  var discoverUserIdentityWithEmailAddressSample = {
    title: 'discoverUserIdentityWithEmailAddress',
    form: emailInputForm,
    run: function() {
      var emailAddress = this.form.getFieldValue('email');
      return this.sampleCode(emailAddress);
    },
    sampleCode: function demoDiscoverUserIdentityWithEmailAddress(emailAddress) {
      var container = CloudKit.getDefaultContainer();

      return container.discoverUserIdentityWithEmailAddress(emailAddress)
        .then(function(response) {
          if(response.hasErrors) {

            // Handle the errors in your app.
            throw response.errors[0];

          } else {
            var title = 'Discovered users by email address:';
            return renderUserIdentity(title, response.users[0]);
          }
        });
    }
  };

  var discoverUserIdentityWithUserRecordNameSample = {
    title: 'discoverUserIdentityWithUserRecordName',
    form: recordNameInputForm,
    run: function() {
      var recordName = this.form.getFieldValue('record-name');
      return this.sampleCode(recordName);
    },
    sampleCode: function demoDiscoverUserIdentityWithUserRecordName(userRecordName) {
      var container = CloudKit.getDefaultContainer();

      return container.discoverUserIdentityWithUserRecordName(userRecordName)
        .then(function(response) {
          if(response.hasErrors) {

            // Handle the errors in your app.
            throw response.errors[0];

          } else {
            var title = 'Discovered users by record name:';
            return renderUserIdentity(title, response.users[0]);
          }
        });
    }
  };


  return [
    fetchUserIdentitySample,
    discoverAllUserIdentitiesSample,
    discoverUserIdentityWithEmailAddressSample,
    discoverUserIdentityWithUserRecordNameSample
  ];

})();/*
<samplecode>
  <abstract>
    Sample code for performing a query. It includes the ability to set a sort condition and an array of filters.
  </abstract>
</samplecode>
*/

CKCatalog.tabs['query'] = (function() {

  var continuationMarker;

  var saveContinuationMarker = function(value) {
    if(value) {
      continuationMarker = value;
      continuationMarkerView.classList.remove('hide');
      continuationMarkerValueView.textContent = value;
    } else {
      removeContinuationMarker();
    }
  };

  var removeContinuationMarker = function() {
    continuationMarker = null;
    continuationMarkerView.classList.add('hide');
  };

  var getContinuationMarker = function() {
    return continuationMarker;
  };

  var hideOwnerRecordName = function() {
    return this.getFieldValue('database-scope') !== 'SHARED';
  };

  var toggleOwnerRecordName = function() {
    this.toggleRow('owner-record-name',!hideOwnerRecordName.call(this));
  };

  var queryForm = new CKCatalog.Form()
    .addSelectField({
      name: 'database-scope',
      label: 'databaseScope:',
      options: [
        { value: 'PUBLIC' },
        { value: 'PRIVATE' },
        { value: 'SHARED' }
      ],
      onChange: toggleOwnerRecordName
    })
    .addInputField({
      name: 'zone-name',
      label: 'zoneName:',
      placeholder: 'Zone name',
      value: CKCatalog.DEFAULT_ZONE_NAME
    })
    .addInputField({
      placeholder: 'Owner record name',
      label: 'ownerRecordName:',
      name: 'owner-record-name',
      hidden: hideOwnerRecordName
    })
    .addInputField({
      name: 'record-type',
      label: 'recordType:',
      placeholder: 'Record type',
      value: 'Items'
    })
    .addInputField({
      name: 'desired-keys',
      label: 'desiredKeys:',
      placeholder: 'Comma separated field names',
      value: 'name,location,asset'
    })
    .addMultipleFields({
      number: 2,
      label: 'sortBy:'
    })
    .addInputField({
      name: 'sort-by-field',
      placeholder: 'Field name'
    })
    .addCheckboxes({
      checkboxes: [{
        name: 'ascending',
        label: 'ascending',
        checked: true
      }]
    })
    .addCheckboxes({
      hidden: true,
      checkboxes: [
        { name: 'sort-by-location', label: 'Sort this field by distance from a location' }
      ]
    })
    .addMultipleFields({
      number: 2,
      hidden: true
    })
    .addInputField({
      name: 'latitude',
      placeholder: 'Latitude',
      value: '37.7833'
    })
    .addInputField({
      name: 'longitude',
      placeholder: 'Longitude',
      value: '-122.4167'
    })
    .addQueryBuilder({
      name: 'filter-by',
      label: 'filterBy:'
    });

  var sortByField = queryForm.fields['sort-by-field'];
  var sortByLocationCheckbox = queryForm.fields['sort-by-location'];

  var toggleRelativeLocationContainer = function() {
    queryForm.toggleRow('latitude',sortByLocationCheckbox.checked);
  };

  sortByField.addEventListener('input', function() {
    if(sortByField.value) {
      toggleRelativeLocationContainer();
    } else {
      queryForm.toggleRow('latitude',false);
    }
    var hasSortByValue = !!sortByField.value;
    queryForm.toggleRow('sort-by-location',hasSortByValue);
  });

  sortByLocationCheckbox.addEventListener('change', toggleRelativeLocationContainer);


  var displayFields = [];

  var continuationMarkerView = document.createElement('div');
  continuationMarkerView.className = 'hide';
  continuationMarkerView.innerHTML = '<div class="light small">At continuation marker: </div>';
  var deleteButton = document.createElement('button');
  deleteButton.className = 'link small';
  deleteButton.textContent = '(delete)';
  deleteButton.onclick = function() {
    removeContinuationMarker();
  };
  continuationMarkerView.firstChild.appendChild(deleteButton);
  var continuationMarkerValueView = document.createElement('div');
  continuationMarkerValueView.className = 'small ellipsis';
  continuationMarkerView.appendChild(continuationMarkerValueView);

  var renderRecords = function(records) {
    var recordsTable = new CKCatalog.Table(displayFields.map(function(fieldName) {
      return fieldName.replace('fields.','');
    }));
    var continuationMarker = getContinuationMarker();
    var title = 'Matching records:';
    if(continuationMarker) {
      title = 'Matching records (run code again to get more):';
    }
    var div = CKCatalog.renderUtils.renderRecords(recordsTable,title,records,displayFields);
    div.insertBefore(continuationMarkerView,div.firstChild);
    return div;
  };

  var querySample = {
    form: queryForm,
    title: 'performQuery',
    run: function() {
      var databaseScope = this.form.getFieldValue('database-scope');
      var recordType = this.form.getFieldValue('record-type');
      var zoneName = this.form.getFieldValue('zone-name');
      var ownerRecordName = databaseScope == 'SHARED' && this.form.getFieldValue('owner-record-name');
      var sortByFieldName = sortByField.value;
      var ascending = this.form.getFieldValue('ascending');
      var lat,long;
      if(this.form.getFieldValue('sort-by-location')) {
        lat = parseFloat(this.form.getFieldValue('latitude'));
        long = parseFloat(this.form.getFieldValue('longitude'));
      }
      var filters = this.form.getFieldValue('filter-by');
      var desiredKeys = this.form.getFieldValue('desired-keys').split(',').map(function(f) { return f.trim(); });
      displayFields = ['recordName'].concat(desiredKeys.map(function(f) { return 'fields.' + f; }));
      return this.sampleCode(databaseScope,zoneName,ownerRecordName,recordType,desiredKeys,sortByFieldName,ascending,lat,long,filters);
    },
    sampleCode: function demoPerformQuery(
      databaseScope,zoneName,ownerRecordName,recordType,
      desiredKeys,sortByField,ascending,latitude,longitude,
      filters
    ) {
      var container = CloudKit.getDefaultContainer();
      var database = container.getDatabaseWithDatabaseScope(
        CloudKit.DatabaseScope[databaseScope]
      );

      // Set the query parameters.
      var query = {
        recordType: recordType
      };

      if(sortByField) {
        var sortDescriptor = {
          fieldName: sortByField,
          ascending: ascending
        };

        if(!isNaN(latitude) && !isNaN(longitude)) {
          sortDescriptor.relativeLocation = {
            latitude: latitude,
            longitude: longitude
          };
        }

        query.sortBy = [sortDescriptor];
      }

      // Convert the filters to the appropriate format.
      query.filterBy = filters.map(function(filter) {
        filter.fieldValue = { value: filter.fieldValue };
        return filter;
      });


      // Set the options.
      var options = {

        // Restrict our returned fields to this array of keys.
        desiredKeys: desiredKeys,

        // Fetch 5 results at a time.
        resultsLimit: 5

      };

      if(zoneName) {
        options.zoneID = { zoneName: zoneName };
        if(ownerRecordName) {
          options.zoneID.ownerRecordName = ownerRecordName;
        }
      }

      // If we have a continuation marker, use it to fetch the next 5 results.
      var continuationMarker = getContinuationMarker();
      if(continuationMarker) {
        options.continuationMarker = continuationMarker;
      }

      // Execute the query.
      return database.performQuery(query,options)
        .then(function (response) {
          if(response.hasErrors) {

            // Handle them in your app.
            throw response.errors[0];

          } else {
            var records = response.records;

            // Save the continuation marker so we can fetch more results.
            saveContinuationMarker(response.continuationMarker);

            return renderRecords(records);
          }
        });
    }
  };

  return [ querySample ];

})();/*
<samplecode>
  <abstract>
    Sample code for CRUD operations on custom zones. Includes forms for user input and rendering helpers.
  </abstract>
</samplecode>
*/

CKCatalog.tabs['zones'] = (function() {

  var createZoneNameForm = function() {
    return (new CKCatalog.Form)
      .addInputField({
        name: 'name',
        placeholder: 'Custom zone name',
        label: 'zoneName:',
        value: 'myCustomZone'
      });
  };

  var renderZones = function(zones) {
    var content = document.createElement('div');
    var heading = document.createElement('h2');
    heading.textContent = 'Zones:';
    var table = new CKCatalog.Table([
      'zoneID', 'atomic', 'syncToken'
    ]).setTextForEmptyRow('No custom zones');
    if(zones.length === 0) {
      table.appendRow([]);
    } else {
      zones.forEach(function(zone) {
        table.appendRow([
          zone.zoneID,
          zone.atomic,
          zone.syncToken
        ]);
      })
    }
    content.appendChild(heading);
    content.appendChild(table.el);
    return content;
  };

  var renderZone = function(zone) {
    var content = document.createElement('div');
    var heading = document.createElement('h2');
    heading.textContent = 'Zone:';
    var table = new CKCatalog.Table().renderObject(zone);
    content.appendChild(heading);
    content.appendChild(table.el);
    return content;
  };

  var runSampleCode = function() {
    var zoneName = this.form.getFieldValue('name');
    return this.sampleCode(zoneName);
  };

  var createZoneSample = {
    title: 'saveRecordZones',
    form: createZoneNameForm(),
    run: runSampleCode,
    sampleCode: function demoSaveRecordZones(zoneName) {
      var container = CloudKit.getDefaultContainer();
      var privateDB = container.privateCloudDatabase;

      return privateDB.saveRecordZones({zoneName: zoneName}).then(function(response) {
        if(response.hasErrors) {

          // Handle any errors.
          throw response.errors[0];

        } else {

          // response.zones is an array of zone objects.
          return renderZone(response.zones[0]);

        }
      });
    }
  };

  var deleteRecordZoneSample = {
    title: 'deleteRecordZones',
    form: createZoneNameForm(),
    run: runSampleCode,
    sampleCode: function demoDeleteRecordZones(zoneName) {
      var container = CloudKit.getDefaultContainer();
      var privateDB = container.privateCloudDatabase;

      return privateDB.deleteRecordZones({zoneName: zoneName}).then(function(response) {
        if(response.hasErrors) {

          // Handle any errors.
          throw response.errors[0];

        } else {

          // response.zones is an array of zone objects.
          return renderZone(response.zones[0]);

        }
      });
    }
  };

  var fetchRecordZoneSample = {
    title: 'fetchRecordZones',
    form: createZoneNameForm(),
    run: runSampleCode,
    sampleCode: function demoFetchRecordZones(zoneName) {
      var container = CloudKit.getDefaultContainer();
      var privateDB = container.privateCloudDatabase;

      return privateDB.fetchRecordZones({zoneName: zoneName}).then(function(response) {
        if(response.hasErrors) {

          // Handle any errors.
          throw response.errors[0];

        } else {

          // response.zones is an array of zone objects.
          return renderZone(response.zones[0]);

        }
      });
    }
  };

  var fetchAllRecordZonesSample = {
    title: 'fetchAllRecordZones',
    sampleCode: function demoFetchAllRecordZones() {
      var container = CloudKit.getDefaultContainer();
      var privateDB = container.privateCloudDatabase;

      return privateDB.fetchAllRecordZones().then(function(response) {
        if(response.hasErrors) {

          // Handle any errors.
          throw response.errors[0];

        } else {

          // response.zones is an array of zone objects.
          return renderZones(response.zones);

        }
      });
    }
  };

  return [ createZoneSample, deleteRecordZoneSample, fetchRecordZoneSample, fetchAllRecordZonesSample ];
})();/*
<samplecode>
  <abstract>
    The sample code for record CRUD operations. Included are helper functions for rendering
    records and for building the forms for user input.
  </abstract>
</samplecode>
*/

CKCatalog.tabs['records'] = (function() {

  var renderRecord = function(record,zoneID,databaseScope) {
    var container = document.createElement('div');

    var actionsContainer = document.createElement('div');
    actionsContainer.className = 'record-actions';

    if(record.shortGUID && record.recordType !== CKCatalog.SHARE_RECORD_TYPE_NAME) {
      var shareButton = document.createElement('button');
      shareButton.setAttribute('type','button');
      shareButton.className = 'share-button link';
      shareButton.textContent = 'Share';
      shareButton.onclick = function() {
        CKCatalog.tabManager.navigateToCodeSample('sharing/shareWithUI',{
          'database-scope': databaseScope,
          'record-name': record.recordName,
          'zone-name': zoneID && zoneID.zoneName,
          'owner-record-name': zoneID && zoneID.ownerRecordName
        });
      };
      actionsContainer.appendChild(shareButton);
    }

    var editButton = document.createElement('button');
    editButton.setAttribute('type','button');
    editButton.className = 'edit-button link';
    editButton.textContent = 'Edit';
    editButton.onclick = function() {
      CKCatalog.tabManager.navigateToCodeSample('records/saveRecords',{
        'database-scope': databaseScope,
        'record-name': record.recordName,
        'change-tag': record.recordChangeTag,
        'zone-name': zoneID && zoneID.zoneName,
        'owner-record-name': zoneID && zoneID.ownerRecordName,
        'record-type': record.recordType,
        'parent-record-name': record.parent && record.parent.recordName,
        'public-permission': record.publicPermission,
        'participants': record.participants,
        'fields': record.fields
      });
    };
    actionsContainer.appendChild(editButton);

    container.appendChild(actionsContainer);

    container.appendChild(CKCatalog.renderUtils.renderRecord('Record:',record));

    return container;
  };

  var renderDeletedRecord = function(record) {
    return CKCatalog.renderUtils.renderRecord('Deleted Record:',record);
  };

  var runSampleCode = function() {
    var recordName = this.form.getFieldValue('record-id');
    var zoneName = this.form.getFieldValue('zone-name');
    var databaseScope = this.form.getFieldValue('database-scope');
    var ownerRecordName;
    if(databaseScope === 'SHARED') {
      ownerRecordName = this.form.getFieldValue('owner-record-name');
    }
    return this.sampleCode(databaseScope,recordName,zoneName,ownerRecordName);
  };

  var hideShareFields = function(bool) {
    return function() {
      return  (this.getFieldValue('record-type') !== CKCatalog.SHARE_RECORD_TYPE_NAME) == bool;
    }
  };

  var toggleShareRows = function() {
    var publicPermission = this.getFieldValue('public-permission');
    var changeTag = this.getFieldValue('change-tag');
    this.toggleArrayField('participants',hideShareFields(false).call(this) && publicPermission === 'NONE');
    this.toggleRow('parent-record-name',hideShareFields(true).call(this));
    this.toggleRow('create-short-guid',hideShareFields(true).call(this));
    this.toggleRow('for-record-name',hideShareFields(false).call(this) && !changeTag);
    this.toggleRow('for-record-change-tag',hideShareFields(false).call(this) && !changeTag);
    this.toggleRow('public-permission',hideShareFields(false).call(this));
  };

  var toggleOwnerRecordName = function() {
    var databaseScope = this.getFieldValue('database-scope');
    this.toggleRow('owner-record-name',databaseScope === 'SHARED');
  };

  var hideOwnerRecordName = function() {
    return this.getFieldValue('database-scope') !== 'SHARED';
  };

  var createRecordIDForm = function() {
    return (new CKCatalog.Form)
      .addSelectField({
        name: 'database-scope',
        label: 'databaseScope:',
        onChange: toggleOwnerRecordName,
        options: [
          { value: 'PRIVATE' },
          { value: 'PUBLIC' },
          { value: 'SHARED' }
        ]
      })
      .addInputField({
        placeholder: 'Record name',
        name: 'record-id',
        label: 'recordName:',
        value: 'NewItem'
      })
      .addInputField({
        placeholder: 'Zone name',
        name: 'zone-name',
        label: 'zoneName:',
        value: CKCatalog.DEFAULT_ZONE_NAME
      })
      .addInputField({
        placeholder: 'Owner record name',
        name: 'owner-record-name',
        label: 'ownerRecordName:',
        hidden: hideOwnerRecordName
      });
  };

  var createItemForm = (new CKCatalog.Form)
    .addSelectField({
      label: 'databaseScope',
      name: 'database-scope',
      options: [
        { value: 'PRIVATE' },
        { value: 'PUBLIC' },
        { value: 'SHARED' }
      ],
      onChange: toggleOwnerRecordName
    })
    .addInputField({
      placeholder: 'Record name',
      name: 'record-name',
      label: 'recordName:'
    })
    .addInputField({
      placeholder: 'Change tag',
      name: 'change-tag',
      label: 'recordChangeTag:',
      onChange: toggleShareRows
    })
    .addInputField({
      placeholder: 'Record type',
      name: 'record-type',
      label: 'recordType:',
      value: 'Items',
      onChange: toggleShareRows
    })
    .addInputField({
      placeholder: 'Zone name',
      name: 'zone-name',
      label: 'zoneName:',
      value: CKCatalog.DEFAULT_ZONE_NAME
    })
    .addInputField({
      placeholder: 'Owner record name',
      name: 'owner-record-name',
      label: 'ownerRecordName:',
      hidden: hideOwnerRecordName
    })
    .addInputField({
      placeholder: 'Name of record to share',
      name: 'for-record-name',
      label: 'forRecordName:',
      hidden: hideShareFields(true)
    })
    .addInputField({
      placeholder: 'Change tag of record to share',
      name: 'for-record-change-tag',
      label: 'forRecordChangeTag',
      hidden: hideShareFields(true)
    })
    .addSelectField({
      name: 'public-permission',
      label: 'publicPermission:',
      hidden: hideShareFields(true),
      onChange: toggleShareRows,
      options: [
        { value: 'NONE' },
        { value: 'READ_ONLY' },
        { value: 'READ_WRITE' }
      ]
    })
    .addArrayField({
      name: 'participants',
      label: 'participants:',
      type: CKCatalog.FIELD_TYPE_SHARE_PARTICIPANT,
      buttonTitle: 'Add participant…',
      hidden: hideShareFields(true)
    })
    .addInputField({
      placeholder: 'Parent record name',
      name: 'parent-record-name',
      label: 'parent:',
      hidden: hideShareFields(false)
    })
    .addDynamicFields({
      label: 'fields:',
      name: 'fields'
    })
    .addCheckboxes({
      hidden: hideShareFields(false),
      checkboxes: [{
        name: 'create-short-guid',
        label: 'Create short GUID'
      }]
    });

  var saveRecordSample = {
    title: 'saveRecords',
    form: createItemForm,
    run: function() {
      var databaseScope = this.form.getFieldValue('database-scope');
      var recordName = this.form.getFieldValue('record-name');
      var changeTag = this.form.getFieldValue('change-tag');
      var zoneName = this.form.getFieldValue('zone-name');
      var recordType = this.form.getFieldValue('record-type');

      // Dependent fields:
      var ownerRecordName, parentRecordName, forRecordName,
        publicPermission, participants, createShortGUID, forRecordChangeTag;

      if(databaseScope === 'SHARED') {
        ownerRecordName = this.form.getFieldValue('owner-record-name');
      }

      if(recordType === CKCatalog.SHARE_RECORD_TYPE_NAME) {
        if(!changeTag) {
          forRecordName = this.form.getFieldValue('for-record-name');
          forRecordChangeTag = this.form.getFieldValue('for-record-change-tag');
        }
        publicPermission = this.form.getFieldValue('public-permission');
        if(publicPermission === 'NONE') {
          participants = this.form.getFieldValue('participants');
        }
      } else {
        parentRecordName = this.form.getFieldValue('parent-record-name');
        createShortGUID = this.form.getFieldValue('create-short-guid');
      }

      var fields = this.form.getFieldValue('fields');

      return this.sampleCode(
        databaseScope,recordName,changeTag,recordType,zoneName, forRecordName, forRecordChangeTag,
        publicPermission,ownerRecordName,participants,parentRecordName,fields,createShortGUID
      );
    },
    sampleCode: function demoSaveRecords(
      databaseScope,recordName,recordChangeTag,recordType,zoneName,
      forRecordName,forRecordChangeTag,publicPermission,ownerRecordName,
      participants,parentRecordName,fields,createShortGUID
    ) {
      var container = CloudKit.getDefaultContainer();
      var database = container.getDatabaseWithDatabaseScope(
        CloudKit.DatabaseScope[databaseScope]
      );

      var options = {
        // By passing and fetching number fields as strings we can use large
        // numbers (up to the server's limits).
        numbersAsStrings: true

      };

      // If no zoneName is provided the record will be saved to the default zone.
      if(zoneName) {
        options.zoneID = { zoneName: zoneName };
        if(ownerRecordName) {
          options.zoneID.ownerRecordName = ownerRecordName;
        }
      }

      var record = {

        recordType: recordType

      };

      // If no recordName is supplied the server will generate one.
      if(recordName) {
        record.recordName = recordName;
      }

      // To modify an existing record, supply a recordChangeTag.
      if(recordChangeTag) {
        record.recordChangeTag = recordChangeTag;
      }

      // Convert the fields to the appropriate format.
      record.fields = Object.keys(fields).reduce(function(obj,key) {
        obj[key] = { value: fields[key] };
        return obj;
      },{});

      // If we are going to want to share the record we need to
      // request a stable short GUID.
      if(createShortGUID) {
        record.createShortGUID = true;
      }

      // If we want to share the record via a parent reference we need to set
      // the record's parent property.
      if(parentRecordName) {
        record.parent = { recordName: parentRecordName };
      }

      if(publicPermission) {
        record.publicPermission = CloudKit.ShareParticipantPermission[publicPermission];
      }

      // If we are creating a share record, we must specify the
      // record which we are sharing.
      if(forRecordName && forRecordChangeTag) {
        record.forRecord = {
          recordName: forRecordName,
          recordChangeTag: forRecordChangeTag
        };
      }

      if(participants) {
        record.participants = participants.map(function(participant) {
          return {
            userIdentity: {
              lookupInfo: { emailAddress: participant.emailAddress }
            },
            permission: CloudKit.ShareParticipantPermission[participant.permission],
            type: participant.type,
            acceptanceStatus: participant.acceptanceStatus
          };
        });
      }

      return database.saveRecords(record,options)
        .then(function(response) {
          if(response.hasErrors) {

            // Handle the errors in your app.
            throw response.errors[0];

          } else {

            return renderRecord(response.records[0],options.zoneID, databaseScope);
          }
      });
    }

  };

  var deleteRecordSample = {
    title: 'deleteRecords',
    form: createRecordIDForm(),
    run: runSampleCode,
    sampleCode: function demoDeleteRecord(
      databaseScope,recordName,zoneName,ownerRecordName
    ) {
      var container = CloudKit.getDefaultContainer();
      var database = container.getDatabaseWithDatabaseScope(
        CloudKit.DatabaseScope[databaseScope]
      );

      var zoneID,options;

      if(zoneName) {
        zoneID = { zoneName: zoneName };
        if(ownerRecordName) {
          zoneID.ownerRecordName = ownerRecordName;
        }
        options = { zoneID: zoneID };
      }

      return database.deleteRecords(recordName,options)
        .then(function(response) {
          if(response.hasErrors) {

            // Handle the errors in your app.
            throw response.errors[0];

          } else {
            var deletedRecord = response.records[0];

            // Render the deleted record.
            return renderDeletedRecord(deletedRecord);
          }
        });
    }
  };

  var fetchRecordSample = {
    title: 'fetchRecords',
    form: createRecordIDForm(),
    run: runSampleCode,
    sampleCode: function demoFetchRecord(
      databaseScope,recordName,zoneName,ownerRecordName
    ) {
      var container = CloudKit.getDefaultContainer();
      var database = container.getDatabaseWithDatabaseScope(
        CloudKit.DatabaseScope[databaseScope]
      );

      var zoneID,options;

      if(zoneName) {
        zoneID = { zoneName: zoneName };
        if(ownerRecordName) {
          zoneID.ownerRecordName = ownerRecordName;
        }
        options = { zoneID: zoneID };
      }

      return database.fetchRecords(recordName,options)
        .then(function(response) {
          if(response.hasErrors) {

            // Handle the errors in your app.
            throw response.errors[0];

          } else {
            var record = response.records[0];

            // Render the fetched record.
            return renderRecord(record,zoneID,databaseScope);
          }
        });
    }
  };

  return [ saveRecordSample, deleteRecordSample, fetchRecordSample ];

})();/*
<samplecode>
  <abstract>
    The sample code for syncing with respect to changes to zones and to records within a zone.
  </abstract>
</samplecode>
 */

CKCatalog.tabs['sync'] = (function() {

  var hideOwnerRecordName = function() {
    return this.getFieldValue('database') !== 'SHARED';
  };

  var toggleOwnerRecordNameAndClearSyncToken = function() {
    this.setFieldValue('sync-token','');
    this.toggleRow('owner-record-name',!hideOwnerRecordName.call(this));
  };

  var databaseOptions = {
    name: 'database',
    label: 'databaseScope:',
    options: [
      { value: 'PRIVATE'},
      { value: 'SHARED' }
    ],
    onChange: toggleOwnerRecordNameAndClearSyncToken
  };

  var zoneSyncForm = (new CKCatalog.Form)
    .addSelectField(databaseOptions)
    .addInputField({
      placeholder: 'Zone name',
      name: 'zone',
      label: 'zoneName:',
      value: 'myCustomZone'
    })
    .addInputField({
      placeholder: 'Owner record name',
      name: 'owner-record-name',
      label: 'ownerRecordName:',
      hidden: hideOwnerRecordName
    })
    .addInputField({
      placeholder: 'Sync token',
      name: 'sync-token',
      label: 'syncToken:'
    });

  var databaseSyncForm = (new CKCatalog.Form)
    .addSelectField(databaseOptions)
    .addInputField({
      placeholder: 'Sync token',
      name: 'sync-token',
      label: 'syncToken:'
    });


  var createSyncTokenView = function(syncToken) {
    var p = document.createElement('p');
    p.innerHTML = '<span class="light small">At syncToken:</span> '
      + '<span class="small">' + syncToken + '</span> ';
    return p;
  };

  var renderRecords = function(databaseScope,zoneName,ownerRecordName,records,syncToken,moreComing) {
    // Populate the syncToken form field with the new syncToken:
    zoneSyncForm.setFieldValue('sync-token',syncToken);

    var content = document.createElement('div');
    var heading = document.createElement('h2');
    var recordsTable = new CKCatalog.Table([
      'recordName','recordType','shortGUID','deleted'
    ])
      .setTextForEmptyRow('No new records')
      .rowIsSelectable(function(row) {
        return !row.data.deleted && row.data.recordName;
      }).addSelectHandler(function(row) {
        CKCatalog.tabManager.navigateToCodeSample('records/fetchRecords', {
          'record-id': row.data['recordName'],
          'zone-name': zoneName,
          'database-scope': databaseScope,
          'owner-record-name': ownerRecordName
        });
      });
    heading.innerHTML = 'Records in ' + zoneName + ' of ' + databaseScope.toLowerCase() + ' database'
      + (moreComing ? '<span id="more-records-coming">' + ' (incomplete)' + '</span>:' : ':');
    if(records.length === 0) {
      recordsTable.appendRow([]);
    } else {
      records.forEach(function(record) {
        var fields = record.fields;
        var name = fields ? fields['name'] : undefined;
        var location = fields ? fields['location'] : undefined;
        recordsTable.appendRow([
          record.recordName,
          record.recordType,
          record.shortGUID,
          record.deleted
        ]);
      });
    }

    content.appendChild(heading);
    content.appendChild(createSyncTokenView(syncToken));
    content.appendChild(recordsTable.el);
    return content;
  };

  var renderZones = function(databaseScope,zones,syncToken,moreComing) {
    // Populate the syncToken form field with the new syncToken:
    databaseSyncForm.setFieldValue('sync-token', syncToken);

    var content = document.createElement('div');
    var heading = document.createElement('h2');
    var zonesTable = new CKCatalog.Table([
      'zoneID','syncToken','atomic','deleted'
    ])
      .setTextForEmptyRow('No new zones')
      .rowIsSelectable(function(row) {
        return row.data.zoneID && row.data.zoneID.zoneName !== CKCatalog.DEFAULT_ZONE_NAME && !row.data.deleted;
      }).addSelectHandler(function(row){
      CKCatalog.tabManager.navigateToCodeSample('sync/fetchRecordZoneChanges',{
        'zone': row.data.zoneID.zoneName,
        'owner-record-name': row.data.zoneID.ownerRecordName,
        'database': databaseScope
      });
    });
    heading.innerHTML = 'Zones in ' + databaseScope.toLowerCase() + ' database'
      + (moreComing ? '<span id="more-zones-coming">' + ' (incomplete)' + '</span>:' : ':');
    if(zones.length === 0) {
      zonesTable.appendRow([]);
    } else {
      zones.forEach(function(zone) {
        zonesTable.appendRow([
          zone.zoneID,
          zone.syncToken,
          zone.atomic,
          zone.deleted
        ]);
      });
    }

    content.appendChild(heading);
    content.appendChild(createSyncTokenView(syncToken));
    content.appendChild(zonesTable.el);
    return content;
  };


  var fetchRecordZoneChangesSample = {
    title: 'fetchRecordZoneChanges',
    form: zoneSyncForm,
    run: function() {
      var zone = this.form.getFieldValue('zone');
      var database = this.form.getFieldValue('database');
      var ownerRecordName = database === 'SHARED' && this.form.getFieldValue('owner-record-name');
      var syncToken = this.form.getFieldValue('sync-token');
      return this.sampleCode(database,zone,ownerRecordName,syncToken);
    },
    sampleCode: function demoFetchRecordZoneChanges(
      databaseScope,zoneName,ownerRecordName,syncToken
    ) {
      var container = CloudKit.getDefaultContainer();
      var database = container.getDatabaseWithDatabaseScope(
        CloudKit.DatabaseScope[databaseScope]
      );

      var zoneID = { zoneName: zoneName };

      if(ownerRecordName) {
        zoneID.ownerRecordName = ownerRecordName;
      }

      var args = {
        zoneID: zoneID,

        // Limit to 5 results.
        resultsLimit: 5
      };

      if(syncToken) {
        args.syncToken = syncToken;
      }

      return database.fetchRecordZoneChanges(args).then(function(response) {
        if(response.hasErrors) {

          // Handle the errors.
          throw response.errors[0];

        } else {
          var zonesResponse = response.zones[0];
          var newSyncToken = zonesResponse.syncToken;
          var records = zonesResponse.records;
          var moreComing = zonesResponse.moreComing;

          return renderRecords(
            databaseScope,
            zoneName,
            ownerRecordName,
            records,
            newSyncToken,
            moreComing
          );
        }
      });
    }

  };

  var fetchDatabaseChangesSample = {
    title: 'fetchDatabaseChanges',
    form: databaseSyncForm,
    run: function() {
      var database = this.form.getFieldValue('database');
      var syncToken = this.form.getFieldValue('sync-token');
      return this.sampleCode(database,syncToken);
    },
    sampleCode: function demoFetchDatabaseChanges(databaseScope,syncToken) {
      var container = CloudKit.getDefaultContainer();
      var database = container.getDatabaseWithDatabaseScope(
        CloudKit.DatabaseScope[databaseScope]
      );

      var opts = {

        // Limit to 5 results.
        resultsLimit: 5
      };

      if(syncToken) {
        opts.syncToken = syncToken;
      }

      return database.fetchDatabaseChanges(opts).then(function(response) {
        if(response.hasErrors) {

          // Handle the errors.
          throw response.errors[0];

        } else {

          var newSyncToken = response.syncToken;

          var zones = response.zones;
          var moreComing = response.moreComing;

          return renderZones(databaseScope,zones,newSyncToken,moreComing);

        }
      });
    }

  };

  return [ fetchDatabaseChangesSample, fetchRecordZoneChangesSample ];
})();
/*
  <samplecode>
    <abstract>
      The sharing sample code: Accepting shares, resolving shared records by short GUID,
      and sharing records by means of the default sharing UI.
    </abstract>
  </samplecode>
 */

CKCatalog.tabs['sharing'] = (function() {

  var renderShareResponse = function(response) {
    var container = document.createElement('div');
    if(response && (response.share || response.record)) {
      if(response.share) {
        container.appendChild(CKCatalog.renderUtils.renderRecord('Share:',response.share));
      }
      if(response.record) {
        container.appendChild(CKCatalog.renderUtils.renderRecord('Record:',response.record));
      }
    } else {
      var h2 = document.createElement('h2');
      h2.textContent = 'Not shared';
      container.appendChild(h2);
    }
    return container;
  };

  var render = function(record) {
    var container = document.createElement('div');
    container.appendChild(CKCatalog.renderUtils.renderRecord(null,record));
    if(record.share) {
      container.appendChild(CKCatalog.renderUtils.renderRecord('Share:',record.share));
    }
    if(record.rootRecord) {
      container.appendChild(CKCatalog.renderUtils.renderRecord('Root Record:',record.rootRecord));
    }
    return container;
  };

  var createShortGUIDForm = function() {
    return (new CKCatalog.Form)
      .addInputField({
        placeholder: 'Short GUID',
        label: 'shortGUID:',
        name: 'shortGUID'
      });
  };

  var hideOwnerRecordName = function() {
    return this.getFieldValue('database-scope') !== 'SHARED';
  };

  var toggleOwnerRecordName = function() {
    this.toggleRow('owner-record-name',!hideOwnerRecordName.call(this));
  };

  var shareWithUIForm = (new CKCatalog.Form)
    .addSelectField({
      name: 'database-scope',
      label: 'databaseScope:',
      options: [
        { value: 'PRIVATE' },
        { value: 'SHARED' }
      ],
      onChange: toggleOwnerRecordName
    })
    .addInputField({
      placeholder: 'Record name',
      label: 'recordName:',
      name: 'record-name'
    })
    .addInputField({
      placeholder: 'Zone name',
      label: 'zoneName:',
      name: 'zone-name'
    })
    .addInputField({
      placeholder: 'Owner record name',
      label: 'ownerRecordName:',
      name: 'owner-record-name',
      hidden: hideOwnerRecordName
    })
    .addInputField({
      placeholder: 'Share title',
      label: 'shareTitle:',
      name: 'share-title'
    })
    .addSelectField({
      name: 'supported-access',
      label: 'supportedAccess:',
      options: [
        { value: 'PRIVATE,PUBLIC', title: 'PUBLIC, PRIVATE' },
        { value: 'PUBLIC' },
        { value: 'PRIVATE' }
      ]
    })
    .addSelectField({
      name: 'supported-permissions',
      label: 'supportedPermissions:',
      options: [
        { value: 'READ_WRITE,READ_ONLY', title: 'READ_WRITE, READ_ONLY' },
        { value: 'READ_WRITE' },
        { value: 'READ_ONLY' }
      ]
    });

  var resolveShortGUIDSample = {
    title: 'fetchRecordInfos',
    form: createShortGUIDForm(),
    run: function() {
      var shortGUID = this.form.getFieldValue('shortGUID');
      return this.sampleCode(shortGUID);
    },
    sampleCode: function demoFetchRecordInfos(shortGUID) {
      var container = CloudKit.getDefaultContainer();

      return container.fetchRecordInfos(shortGUID)
        .then(function(response) {
          if(response.hasErrors) {

            // Handle them in your app.
            throw response.errors[0];

          } else {
            var result = response.results[0];
            return render(result);
          }
        });
    }

  };

  var acceptShareSample = {
    title: 'acceptShares',
    form: createShortGUIDForm(),
    run: function() {
      var shortGUID = this.form.getFieldValue('shortGUID');
      return this.sampleCode(shortGUID);
    },
    sampleCode: function demoAcceptShares(shortGUID) {
      var container = CloudKit.getDefaultContainer();

      return container.acceptShares(shortGUID)
        .then(function(response) {
          if(response.hasErrors) {

            // Handle them in your app.
            throw response.errors[0];

          } else {
            var result = response.results[0];
            return render(result);
          }
        });
    }
  };

  var shareWithUISample = {
    title: 'shareWithUI',
    form: shareWithUIForm,
    run: function() {
      var databaseScope = this.form.getFieldValue('database-scope');
      var recordName = this.form.getFieldValue('record-name');
      var zoneName = this.form.getFieldValue('zone-name');
      var ownerRecordName = databaseScope === 'SHARED' && this.form.getFieldValue('owner-record-name');
      var shareTitle = this.form.getFieldValue('share-title');
      var supportedAccess = this.form.getFieldValue('supported-access').split(',');
      var supportedPermissions = this.form.getFieldValue('supported-permissions').split(',');

      // Hide the dialog as CloudKit JS has it's own spinner for this UI.
      CKCatalog.dialog.hide();

      return this.sampleCode(databaseScope,recordName,zoneName,ownerRecordName,shareTitle,supportedAccess,supportedPermissions);
    },
    sampleCode: function demoShareWithUI(
      databaseScope,recordName,zoneName,ownerRecordName,
      shareTitle,supportedAccess,supportedPermissions
    ) {
      var container = CloudKit.getDefaultContainer();
      var database = container.getDatabaseWithDatabaseScope(
        CloudKit.DatabaseScope[databaseScope]
      );

      var zoneID = { zoneName: zoneName };

      if(ownerRecordName) {
        zoneID.ownerRecordName = ownerRecordName;
      }

      return database.shareWithUI({

        record: {
          recordName: recordName
        },
        zoneID: zoneID,
        
        shareTitle: shareTitle,

        supportedAccess: supportedAccess,

        supportedPermissions: supportedPermissions

      }).then(function(response) {
        if(response.hasErrors) {

          // Handle the errors in your app.
          throw response.errors[0];

        } else {

          return renderShareResponse(response);
        }
      });
    }
  };

  return [ resolveShortGUIDSample, acceptShareSample, shareWithUISample ];
})();
/*
<samplecode>
  <abstract>
    The sample code for CRUD operations on subscriptions. Includes forms and rendering helpers.
  </abstract>
</samplecode>
*/

CKCatalog.tabs['subscriptions'] = (function() {

  var subscriptionTypeForm = (new CKCatalog.Form)
    .addSelectField({
      name: 'type',
      label: 'subscriptionType:',
      options: [
        { value: 'zone', selected: true },
        { value: 'query' }
      ]
    })
    .addInputField({
      placeholder: 'Zone name',
      name: 'zone',
      label: 'zoneName:',
      value: 'myCustomZone'
    })
    .addInputField({
      placeholder: 'Record type',
      name: 'record-type',
      label: 'recordType:',
      value: 'Items',
      hidden: true
    })
    .addCheckboxes({
      label: 'firesOn:',
      hidden: true,
      checkboxes: [
        { name: 'fires-on-create', label: 'create', value: 'create', checked: true },
        { name: 'fires-on-update', label: 'update', value: 'update', checked: true },
        { name: 'fires-on-delete', label: 'delete', value: 'delete', checked: true }
      ]
    })
    .addQueryBuilder({
      name: 'filter-by',
      label: 'filterBy:',
      hidden: true
    });

  var createSubscriptionIDForm = function() {
    return (new CKCatalog.Form)
      .addInputField({
        name: 'subscription-id',
        label: 'subscriptionID:',
        placeholder: 'Subscription ID'
      });
  };

  var fetchSubscriptionSubscriptionIDForm = createSubscriptionIDForm();
  var deleteSubscriptionSubscriptionIDForm = createSubscriptionIDForm();

  var subscriptionTypeField = subscriptionTypeForm.fields['type'];
  var zoneNameField = subscriptionTypeForm.fields['zone'];
  var firesOnFields = {
    create: subscriptionTypeForm.fields['fires-on-create'],
    update: subscriptionTypeForm.fields['fires-on-update'],
    delete: subscriptionTypeForm.fields['fires-on-delete']
  };

  subscriptionTypeField.addEventListener('change',function() {
    var isQuerySubscription = subscriptionTypeField.value === 'query';
    subscriptionTypeForm.toggleRow('fires-on-create',isQuerySubscription);
    subscriptionTypeForm.toggleRow('record-type',isQuerySubscription);
    subscriptionTypeForm.toggleFilters('filter-by',isQuerySubscription);
  });

  var runSampleCode = function() {
    var subscriptionID = this.form.getFieldValue('subscription-id');
    return this.sampleCode(subscriptionID);
  };

  var renderSubscriptions = function(title,subscriptions) {
    var content = document.createElement('div');
    var heading = document.createElement('h2');
    heading.textContent = title;
    var table = new CKCatalog.Table([
      'subscriptionID', 'subscriptionType', 'zoneID', 'firesOn', 'query', 'zoneWide'
    ]).setTextForEmptyRow('No subscriptions');
    if(subscriptions.length) {
      subscriptions.forEach(function (subscription,i) {
        if(i === 0) {

          // Populate subscription ID form fields with this ID for convenience.
          fetchSubscriptionSubscriptionIDForm.fields['subscription-id'].value = subscription.subscriptionID;
          deleteSubscriptionSubscriptionIDForm.fields['subscription-id'].value = subscription.subscriptionID;

        }
        table.appendRow([
          subscription.subscriptionID,
          subscription.subscriptionType,
          subscription.zoneID,
          subscription.firesOn,
          subscription.query,
          subscription.zoneWide
        ]);
      });
    } else {
      table.appendRow([]);
    }
    content.appendChild(heading);
    content.appendChild(table.el);
    return content;
  };

  var renderSubscription = function(title,object) {
    var content = document.createElement('div');
    var heading = document.createElement('h2');
    heading.textContent = title;
    var table = new CKCatalog.Table().renderObject(object);
    content.appendChild(heading);
    content.appendChild(table.el);
    return content;
  };

  var saveSubscriptionSample = {
    title: 'saveSubscriptions',
    form: subscriptionTypeForm,
    run: function() {
      var subscriptionType = subscriptionTypeField.value;
      var zoneName = zoneNameField.value;
      var recordType;
      var firesOn;
      var filterBy;
      if(subscriptionType === 'query') {
        firesOn = [];
        recordType = this.form.getFieldValue('record-type');
        for(var k in firesOnFields) {
          if(firesOnFields[k].checked) {
            firesOn.push(firesOnFields[k].value);
          }
        }
        filterBy = this.form.getFieldValue('filter-by');
      }
      return this.sampleCode(subscriptionType,zoneName,recordType,firesOn,filterBy);
    },
    sampleCode: function demoSaveSubscriptions(
      subscriptionType,zoneName,recordType,firesOn,filterBy
    ) {
      var container = CloudKit.getDefaultContainer();
      var privateDB = container.privateCloudDatabase;

      var subscription = {
        subscriptionType: subscriptionType
      };

      // If no zoneName is supplied for a query subscription,
      // it will be zone-wide.
      if(zoneName) {
        subscription.zoneID = { zoneName: zoneName };
      }

      if(subscriptionType === 'query' && firesOn) {

        subscription.firesOn = firesOn; // An array
                                        // like [ 'create', 'update', 'delete' ]

        subscription.query = { // A query object.
          recordType: recordType
        };

        if(filterBy) {

          subscription.query.filterBy = filterBy.map(function(filter) {
            filter.fieldValue = { value: filter.fieldValue };
            return filter;
          });
        }

      }

      return privateDB.saveSubscriptions(subscription).then(function(response) {
        if(response.hasErrors) {

          // Handle them in your app.
          throw response.errors[0];

        } else {
          var title = 'Created subscription:';
          return renderSubscription(title,response.subscriptions[0]);
        }
      });
    }
  };

  var deleteSubscriptionSample = {
    title: 'deleteSubscriptions',
    form: deleteSubscriptionSubscriptionIDForm,
    run: runSampleCode,
    sampleCode: function demoDeleteSubscriptions(subscriptionID) {
      var container = CloudKit.getDefaultContainer();
      var privateDB = container.privateCloudDatabase;

      var subscription = {
        subscriptionID: subscriptionID
      };

      return privateDB.deleteSubscriptions(subscription).then(function(response) {
        if(response.hasErrors) {

          // Handle the error.
          throw response.errors[0];

        } else {
          var title = 'Deleted subscription:';
          return renderSubscription(title,response.subscriptions[0]);
        }
      });
    }
  };

  var fetchSubscriptionSample = {
    title: 'fetchSubscriptions',
    form: fetchSubscriptionSubscriptionIDForm,
    run: runSampleCode,
    sampleCode: function demoFetchSubscriptions(subscriptionID) {
      var container = CloudKit.getDefaultContainer();
      var privateDB = container.privateCloudDatabase;

      var subscription = {
        subscriptionID: subscriptionID
      };

      return privateDB.fetchSubscriptions(subscription).then(function(response) {
        if(response.hasErrors) {

          // Handle the error.
          throw response.errors[0];

        } else {
          var title = 'Fetched subscription:';
          return renderSubscription(title,response.subscriptions[0]);
        }
      });
    }
  };

  var fetchAllSubscriptionsSample = {
    title: 'fetchAllSubscriptions',
    sampleCode: function demoFetchAllSubscriptions() {
      var container = CloudKit.getDefaultContainer();
      var privateDB = container.privateCloudDatabase;

      return privateDB.fetchAllSubscriptions().then(function(response) {
        if(response.hasErrors) {

          // Handle the error.
          throw response.errors[0];

        } else {
          var title = 'Subscriptions:';
          return renderSubscriptions(title,response.subscriptions);
        }
      });
    }
  };

  return [ saveSubscriptionSample, deleteSubscriptionSample, fetchSubscriptionSample, fetchAllSubscriptionsSample ];

})();/*
<samplecode>
  <abstract>
    The notifications sample code with helper functions to add an alert to the left-hand menu,
    to clear 'new' notifications, and to render the notifications in a table.
  </abstract>
</samplecode>
*/
CKCatalog.tabs['notifications'] = (function() {

  var alertTextContainer = document.getElementById('number-of-alerts');
  var notificationsAlertContainer = document.querySelector('.menu-item[href="#notifications"] .alert');
  var notificationsSubtitle = document.getElementById('connected-text');
  var unseenNotifications = 0;

  var areNotificationsVisible = function() {
    return window.location.hash === '#notifications';
  };

  var setUnseenNotifications = function(val) {
    unseenNotifications = val;
    alertTextContainer.textContent = val + '';
  };

  var showOrHideAlert = function() {
    if(areNotificationsVisible() || unseenNotifications === 0) {
      notificationsAlertContainer.classList.add('hide');
      notificationsAlertContainer.parentNode.classList.remove('notify');
    } else {
      notificationsAlertContainer.classList.remove('hide');
      notificationsAlertContainer.parentNode.classList.add('notify');
    }
  };

  var updateNotificationsSubtitle = function(text) {
    notificationsSubtitle.innerHTML = '<span class="green">' + text + '</span>';
  };

  window.addEventListener('hashchange',function(hashChangeEvent) {

    // Let's remove the 'new' class from the rows when leaving the notifications page and reset unseen notifications.
    if(/#notifications/.test(hashChangeEvent.oldURL)) {
      setUnseenNotifications(0);
      var rows = notificationsTable.body.childNodes;
      for(var i=0; i<rows.length; i++) {
        rows[i].classList.remove('new');
      }
    }
    showOrHideAlert();
  });

  var notificationsTable = new CKCatalog.Table(
    ['notificationID','notificationType','subscriptionID','zoneID']
  ).setTextForEmptyRow('No notifications').appendRow([]);

  var renderNotificationsTable = function() {
    var content = document.createElement('div');
    var heading = document.createElement('h2');
    heading.textContent = 'Notifications:';
    content.appendChild(heading);
    content.appendChild(notificationsTable.el);
    return content;
  };

  var appendNotificationToTable = function(notificationID,notificationType,subscriptionID,zoneID) {
    if(!areNotificationsVisible()) {
      setUnseenNotifications(unseenNotifications + 1);
      showOrHideAlert();
    } else {
      setUnseenNotifications(0);
    }
    var tbody = notificationsTable.body;
    var firstRow = tbody.firstChild;
    if(firstRow.classList.contains('empty')) {
      tbody.removeChild(firstRow);
    }
    notificationsTable.prependRow([
      notificationID,notificationType,subscriptionID,zoneID
    ]);
    tbody.firstChild.classList.add('new');
  };

  var addNotificationListenerSample = {
    title: 'registerForNotifications',
    sampleCode: function demoRegisterForNotifications() {
      var container = CloudKit.getDefaultContainer();

      // Check if our container is already registered for notifications. If so, return.
      if(container.isRegisteredForNotifications) {
        return CloudKit.Promise.resolve();
      }

      function renderNotification(notification) {
        appendNotificationToTable(
          notification.notificationID,
          notification.notificationType,
          notification.subscriptionID,
          notification.zoneID
        );
      }

      // Add a notification listener which appends the received notification object
      // to the table below.
      container.addNotificationListener(renderNotification);

      // Now let's park a connection with the notification backend so that
      // we can receive notifications.
      return container.registerForNotifications().then(function(container) {
        if(container.isRegisteredForNotifications) {

          // Update the subtitle in the left-hand menu.
          updateNotificationsSubtitle('Connected');

          return renderNotificationsTable();
        }
      });
    }
  };

  return [ addNotificationListenerSample ];
})();CKCatalog.tabManager=(function(){var self={};var page=document.getElementById('page');var scrollView=page.parentNode;var menuItems=document.querySelectorAll('.menu-item');var runButton=document.getElementById('run-button');var expandButton=document.getElementById('expand-left-column');var contractButton=document.getElementById('contract-left-column');var leftPane=document.getElementById('left-pane');var subTabMenuItems;var selectedTabName;var selectedSubTabIndex=0;var subTabMenus={};var tabs={};var defaultRoute=['readme'];leftPane.addEventListener('transitionend',function(){if(leftPane.classList.contains('expanded')){contractButton.classList.remove('hide');leftPane.style.overflow='visible';}else{expandButton.classList.remove('hide');}});var expandLeftPane=function(){leftPane.classList.add('expanded');expandButton.classList.add('hide');};var contractLeftPane=function(){leftPane.classList.remove('expanded');contractButton.classList.add('hide');leftPane.style.overflow='hidden';for(var i=0;i<menuItems.length;i++){menuItems[i].parentNode.classList.remove('expanded');}};window.addEventListener('resize',function(){if(window.outerWidth<1140){contractLeftPane();}});expandButton.onclick=expandLeftPane;contractButton.onclick=contractLeftPane;leftPane.addEventListener('click',function(e){var node=e.target;if(!e.target.classList.contains('caret')&&!e.target.classList.contains('tab-menu-item')){node=e.target.parentNode.parentNode;}
if(node.classList.contains('caret')){node.classList.toggle('expanded');e.preventDefault();if(leftPane.offsetWidth<50){expandLeftPane();}}});var codeHighlightingIsInitialized=false;var highlightCode=function(){if(typeof hljs!=='undefined'){codeHighlightingIsInitialized=true;try{var codeSamples=document.querySelectorAll('pre code');for(var j=0;j<codeSamples.length;j++){hljs.highlightBlock(codeSamples[j]);}}catch(e){console.error('Unable to highlight sample code: '+e.message);}}};var runCode=function(){if(typeof CloudKit==='undefined'){CKCatalog.dialog.showError(new Error('The variable CloudKit is not defined. The CloudKit JS library may still be loading or may have failed to load.'));return;}
if(selectedTabName){var selectedTab=CKCatalog.tabs[selectedTabName];var subTab=selectedTab[selectedSubTabIndex];CKCatalog.dialog.show('Executing…');var run=subTab.run?subTab.run:subTab.sampleCode;try{run.call(subTab).then(function(content){CKCatalog.dialog.hide();if(content&&content instanceof Node){subTab.content.replaceChild(content,subTab.content.firstChild);var heading=document.createElement('h1');heading.textContent='Result';content.insertBefore(heading,content.firstChild);}
var padding=39;var change=subTab.content.offsetTop-padding;subTab.content.style.minHeight=(scrollView.offsetHeight-padding)+'px';var start=scrollView.scrollTop;var startTime=0;var duration=500;var easingValue=function(t){var tc=(t/=duration)*t*t;return start+change*(tc);};var animateScroll=function(timestamp){if(!startTime){startTime=timestamp;}
var progress=timestamp-startTime;scrollView.scrollTop=easingValue(Math.min(progress,duration));if(progress<duration){window.requestAnimationFrame(animateScroll);}else{var results=subTab.content.firstChild;results.className='results';}};window.requestAnimationFrame(animateScroll);},CKCatalog.dialog.showError);}catch(e){CKCatalog.dialog.showError(e);}}};runButton.onclick=runCode;runButton.onmousedown=function(){runButton.parentNode.classList.add('active');};runButton.onmouseup=function(){runButton.parentNode.classList.remove('active');};var createSampleCodeSegment=function(tabSegment,selected){var el=document.createElement('div');el.className='page-segment'+(selected?' selected':'');el.appendChild(tabSegment.description);if(tabSegment.sampleCode){var sampleCode=document.createElement('pre');sampleCode.className='javascript sample-code';var sampleCodeString=tabSegment.sampleCode.toString();var indentationCorrection=sampleCodeString.lastIndexOf('}')-sampleCodeString.lastIndexOf('\n')-1;var regExp=new RegExp('\n[ ]{'+indentationCorrection+'}','g');sampleCode.innerHTML='<code>'+sampleCodeString.replace(regExp,'\n')+'</code>';if(!tabSegment.content){tabSegment.content=document.createElement('div');tabSegment.content.className='content';tabSegment.content.innerHTML='<div class="results"></div>';}
if(tabSegment.form){tabSegment.form.onSubmit(runCode);var formContainer=document.createElement('div');formContainer.className='input-fields';formContainer.appendChild(tabSegment.form.el);el.appendChild(formContainer);sampleCode.classList.add('no-top-border');}
el.appendChild(sampleCode);el.appendChild(tabSegment.content);}
return el;};var createSubTabMenu=function(){var menu=document.createElement('div');menu.className='tab-menu ';return menu;};var getTransformedTitleForHash=function(title){return title.replace(/( |\.)/g,'-');};var createSubTabMenuItem=function(name){var item=document.createElement('div');item.className='tab-menu-item';item.textContent=name;item.onclick=function(){window.location.hash=item.parentNode.parentNode.querySelector('a.menu-item').getAttribute('href')+
'/'+getTransformedTitleForHash(name);scrollView.scrollTop=0;};return item;};for(var tabName in CKCatalog.tabs){if(CKCatalog.tabs.hasOwnProperty(tabName)){if(CKCatalog.tabs[tabName].length>1){var subMenuContainer=document.querySelector('.left-pane .menu-items .menu-item-container.'+tabName);var subTabMenu=createSubTabMenu(tabName);subTabMenus[tabName]=[];CKCatalog.tabs[tabName].forEach(function(subTab){subTabMenus[tabName].push(subTabMenu.appendChild(createSubTabMenuItem(subTab.title)));});subMenuContainer.appendChild(subTabMenu);subMenuContainer.classList.add('caret');}}}
var getRoute=function(){var hash=window.location.hash;if(!hash||hash[0]!=='#')return defaultRoute;return hash.substr(1).split('/')||defaultRoute;};var selectTab=function(){var route=getRoute();var tabName=route[0];var subTabTitle=route[1];var tab=CKCatalog.tabs[tabName];var subTabIndex=tab&&tab.reduce(function(value,codeSample,index){var title=codeSample.title;if(title&&getTransformedTitleForHash(title)===subTabTitle){return index;}
return value;},subTabTitle?-1:0);if(!tab||subTabIndex<0){tabName='not-found';tab=CKCatalog.tabs[tabName];subTabIndex=0;}
if(tabName!==selectedTabName){if(tab[0]&&tab[0].sampleCode){runButton.disabled=false;runButton.parentNode.classList.remove('disabled');}else{runButton.disabled=true;runButton.parentNode.classList.add('disabled');}
for(var i=0;i<menuItems.length;i++){var menuItem=menuItems[i];if(menuItem.attributes.href.value==='#'+tabName){menuItem.parentNode.classList.add('selected');}else{menuItem.parentNode.classList.remove('selected');}}
subTabMenuItems=subTabMenus[tabName];if(!tabs.hasOwnProperty(tabName)){tabs[tabName]=document.createElement('div');var pageSegments=tabs[tabName];pageSegments.className='page-segments';var descriptions=document.getElementById(tabName);tab.forEach(function(tabSegment,index){if(!tabSegment.description){tabSegment.description=descriptions.firstElementChild;}
pageSegments.appendChild(createSampleCodeSegment(tabSegment,index===selectedSubTabIndex));});page.replaceChild(pageSegments,page.firstElementChild);highlightCode();}else{page.replaceChild(tabs[tabName],page.firstElementChild);}
selectedTabName=tabName;}
if(subTabIndex>=tabs[tabName].childElementCount||subTabIndex<0){subTabIndex=0;}
var subTabs=tabs[tabName].childNodes;for(var index=0;index<subTabs.length;index++){if(index===subTabIndex){subTabs[index].classList.add('selected');}else{subTabs[index].classList.remove('selected');}
if(subTabMenuItems){var subTabMenuItem=subTabMenuItems[index];if(index===subTabIndex){subTabMenuItem.classList.add('selected');}else{subTabMenuItem.classList.remove('selected');}}}
selectedSubTabIndex=subTabIndex;if(leftPane.classList.contains('expanded')){setTimeout(contractLeftPane,300);}
scrollView.scrollTop=0;};window.addEventListener('hashchange',selectTab);selectTab();self.initializeCodeHighlighting=function(){var link=document.createElement('link');link.setAttribute('rel','stylesheet');link.setAttribute('href','https://cdn.apple-cloudkit.com/cloudkit-catalog/xcode.css');document.getElementsByTagName('head')[0].appendChild(link);link.onload=function(){if(!codeHighlightingIsInitialized){highlightCode();}}};self.navigateToCodeSample=function(route,formFields){if(!route)return;var parsedRoute=route.split('/');var tab=CKCatalog.tabs[parsedRoute[0]];if(!tab)return;var subtabTitle=parsedRoute[1];var subtab=tab.find(function(sampleCode){return sampleCode.title===subtabTitle;})||tab[0];if(subtab.form){subtab.form.reset();if(formFields){for(var key in formFields){if(formFields.hasOwnProperty(key)&&formFields[key]!==undefined&&formFields[key]!==null){subtab.form.setFieldValue(key,formFields[key]);}}}}
window.location.hash=route;if(scrollView.scrollTop){scrollView.scrollTop=0;}};return self;})();window.addEventListener('cloudkitloaded',function(){var getParameterByName=CKCatalog.QueryString.getParameterByName;var containerId=getParameterByName('container')||'iCloud.com.example.CloudKitCatalog';var apiToken=getParameterByName('apiToken')||'b86f0b5db29f04f45badba0366f39b7130a505f07765b5ba3a2ceb0cb3d96c0c';var environment=getParameterByName('environment')||'production';var privateDBPartition=getParameterByName('privateDBPartition');var publicDBPartition=getParameterByName('publicDBPartition');var username=getParameterByName('user');var useApiTokenAuth=!privateDBPartition||!publicDBPartition;var containerConfig={containerIdentifier:containerId,environment:environment};var services={logger:console};if(useApiTokenAuth){containerConfig.apiTokenAuth={apiToken:apiToken,persist:true};}else{containerConfig.auth=false;containerConfig.privateDatabasePartition=privateDBPartition.replace('dashboardws','databasews');containerConfig.publicDatabasePartition=publicDBPartition.replace('dashboardws','databasews');services.fetch=function(url,options,fetch){if(!/feedbackws/.test(url)){options.credentials='include';}
return fetch(url,options);};}
try{CloudKit.configure({containers:[containerConfig],services:services});if(useApiTokenAuth){CKCatalog.tabs['authentication'][0].sampleCode().catch(CKCatalog.dialog.showError);}else{document.querySelector('.menu-item-container.authentication').style.display='none';if(username){document.getElementById('username').textContent=username;}}
document.getElementById('config-container').textContent=containerId;document.getElementById('config-environment').textContent=environment;document.getElementById('config-bar').classList.add('alert-showing');document.getElementById('page').parentNode.classList.add('alert-showing');}catch(e){CKCatalog.dialog.showError(e);}});