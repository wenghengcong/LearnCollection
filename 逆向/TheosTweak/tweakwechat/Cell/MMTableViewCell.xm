
%hook MMTableViewCell

- (id)initWithStyle:(long long)arg1 reuseIdentifier:(id)arg2
{
	%log;
	return %orig;
}

%end