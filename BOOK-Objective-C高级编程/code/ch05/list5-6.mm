{
	/*
 	 * Assume that a Block on the stack was assigned to the variable 'blk'
	 */

	blk_t tmp = [blk copy];

	/*
	 * A Block on the heap is assigned to the variable 'tmp'.
	 * 'tmp' has ownership of it because of its strong reference.
	 */

	blk = tmp;

	/*
	 * The Block in the variable 'tmp' is assigned to the variable 'blk'.
	 * 'blk' has ownership of it because of its strong reference.
	 *
	 * The Block, which was originally assigned to 'blk',
	 * is not affected by this assignment, because it is on the stack.
	 *
	 * At this moment, the variables 'blk' and 'tmp' have ownership of the Block.
	 */
} 
	/*
	 * Leaving the variable scope 'tmp',
	 * and its strong reference disappears and the Block is released. 
	 *
	 * Because the variable 'blk' has ownership of it, the Block isn't disposed of.
￼￼   */ 
{

	/*
	 * The variable 'blk' has the Block on the heap.
	 * 'blk' has ownership of it because of its strong reference. 
	 */
	 
	blk_t tmp = [blk copy];

	/*
	 * A Block on the heap is assigned to the variable 'tmp'.
	 * 'tmp' has ownership of it because of its strong reference. 
	 */

	blk = tmp;

	/*
	 * Because the different value is assigned to the variable 'blk',
	 * The strong reference to the Block, which was assigned in the variable 'blk', disappears
	 * and the Block is released. 
	 *
	 * The variable 'tmp' has ownership of the Block,
	 * The Block isn't disposed of. 
	 *
	 * The Block in the variable 'tmp' is assigned to the variable 'blk'.
	 * The variable 'blk' has ownership because of the strong reference.
	 *
	 * At this moment, the variables 'blk' and 'tmp' have ownership of the Block. 
	 */
} 
	/*
	 * Leaving the variable scope 'tmp',
	 * and its strong reference disappears and the Block is released.
	 *
 	 * Because the variable 'blk' has ownership of it, the Block isn't disposed of. 
 	 */

	/*
	 * repeating ... 
	 */