////////////////////////////////////////////////////////////////////////////////
// Lab 4
////////////////////////////////////////////////////////////////////////////////

// Include the checkoff program:
.include "checkoff.uasm"

// Leave the following as zero to run ALL the test cases, and get your solution
//   validated if all pass.  If you have trouble with test case N, set it to N
//   to run JUST that test case (for easier debugging):
TestCase:       LONG(3)

// Quicksort-in-place code.  We include the C/Python version here as a comment;
// you can use this as a model for your Beta assembly version:

//def partition(array,left,right):
//    # choose middle element of array as pivot
//    pivotIndex = (left+right) >> 1;
//    pivotValue = array[pivotIndex]
//
//    # swap array[right] and array[pivotIndex]
//    # note that we already store array[pivotIndex] in pivotValue
//    array[pivotIndex] = array[right]
//
//    # elements <= the pivot are moved to the left (smaller indices)
//    storeIndex = left
//    for i in xrange(left,right):  # don't include array[right]
//        temp = array[i]
//        if temp <= pivotValue:
//            array[i] = array[storeIndex]
//            array[storeIndex] = temp
//            storeIndex += 1
//
//    # move pivot to its final place
//    array[right] = array[storeIndex]
//    array[storeIndex] = pivotValue;
//    return storeIndex;

partition:
		partition_pivot_value=R1
		partition_ptr=R2
		partition_store_ptr=R3
		partition_i=R4
		partition_temp=R5
		partition_array=R6
		partition_left=R7
		partition_right=R8
		partition_test=R9
		
		PUSH(LP)
		PUSH(BP)
		MOVE(SP,BP)
		
		PUSH(partition_pivot_value)
		PUSH(partition_ptr)
		PUSH(partition_store_ptr)
		PUSH(partition_i)
		PUSH(partition_temp)
		PUSH(partition_test)
		PUSH(partition_array)
		PUSH(partition_left)
		PUSH(partition_right)
		
		// i have to idea why named registers doesn't work here -_-
		LD(BP, -12, R6) // LD(BP, -12, quicksort_array)
		LD(BP, -16, R7)  // LD(BP, -16, quicksort_left)
		LD(BP, -20, R8) // LD(BP, -20, quicksort_right)
		
		// partition_ptr = array + (left + right) / 2 (ptr is a address of pivot element)
		ADD(partition_left, partition_right, partition_ptr) // ptr = left + right;
		SHRC(partition_ptr, 1, partition_ptr) // ptr /= 2
		SHLC(partition_ptr, 2, partition_ptr) // ptr *= 4 (4 byte addresses)
		ADD(partition_array, partition_ptr, partition_ptr) // ptr = array + ptr
		
		// pivot_value = pivot element
		LD(partition_ptr, partition_pivot_value)
		
		// temp = array[right]
		SHLC(partition_right, 2, partition_temp)
		ADD(partition_array, partition_temp, partition_temp)
		LD(partition_temp, partition_temp)
		
		// *ptr = temp (move right element to pivot position)
		ST(partition_temp, 0, partition_ptr)
		
		// store_ptr = &array[left]
		SHLC(partition_left, 2, partition_store_ptr)
		ADD(partition_array, partition_store_ptr, partition_store_ptr)
		
		// ptr = store_ptr
		MOVE(partition_store_ptr, partition_ptr)
		
		// for (i = left; i < right; ++i):
		MOVE(partition_left, partition_i)
	partition_for:
		CMPLT(partition_i, partition_right, partition_test)
		BF(partition_test, partition_for_end)
		
		LD(partition_ptr, partition_temp) // tmp = *ptr
		CMPLT(partition_temp, partition_pivot_value, partition_test)
		BF(partition_test, partition_for_update)
		LD(partition_store_ptr, partition_test)
		ST(partition_test, 0, partition_ptr) // *ptr = *store_ptr;
		ST(partition_temp, 0, partition_store_ptr) // *store_ptr = temp
		ADDC(partition_store_ptr, 4, partition_store_ptr) // store_ptr += 4
	partition_for_update:
		ADDC(partition_i, 1, partition_i)
		ADDC(partition_ptr, 4, partition_ptr)
		BEQ(R31, partition_for)
	partition_for_end:
	
	// *ptr = *store_ptr
	LD(partition_store_ptr, partition_temp)
	ST(partition_temp, 0, partition_ptr)
	
	// *store_ptr = pivot_value
	ST(partition_pivot_value, 0, partition_store_ptr)

partition_end:
		POP(partition_pivot_value)
		POP(partition_ptr)
		POP(partition_store_ptr)
		POP(partition_i)
		POP(partition_temp)
		POP(partition_test)
		POP(partition_array)
		POP(partition_left)
		POP(partition_right)
		
        MOVE(BP, SP)
        POP(BP)
        POP(LP)
        JMP(LP)


//def quicksort(array, left, right):
//    if left < right:
//        pivotIndex = partition(array,left,right)
//        quicksort(array,left,pivotIndex-1)
//        quicksort(array,pivotIndex+1,right)

// quicksort(ArrayBase, left, right)
quicksort:
		quicksort_array=R5
		quicksort_left=R1
		quicksort_right=R2
		quicksort_test=R3
		quicksort_pivotIndex=R4
        PUSH(LP)
        PUSH(BP)
        MOVE(SP, BP)
		PUSH(quicksort_array)
		PUSH(quicksort_left)
		PUSH(quicksort_right)
		PUSH(quicksort_test)
		PUSH(quicksort_pivotIndex)
		
		LD(BP, -12, quicksort_array)
		LD(BP, -16, quicksort_left)
		LD(BP, -20, quicksort_right)
		
		CMPLT(quicksort_left, quicksort_right, quicksort_test)
		BF(quicksort_test, quicksort_end)
		
		/* TODO
			number of push's/pop's can be reduced
			by using ST()
		*/

		// quicksort_pivotIndex = partition(array, left, right)
		PUSH(quicksort_right)
		PUSH(quicksort_left)
		PUSH(quicksort_array)
		CALL(partition)
		MOVE(R0, quicksort_pivotIndex)
		POP(quicksort_array)
		POP(quicksort_left)
		POP(quicksort_right)
		
		// quicksort(array, left, pivotIndex-1)
		ADDC(quicksort_pivotIndex, -1, quicksort_pivotIndex)
		PUSH(quicksort_pivotIndex)
		PUSH(quicksort_left)
		PUSH(quicksort_array)
		CALL(quicksort)
		POP(quicksort_array)
		POP(quicksort_left)
		POP(quicksort_pivotIndex)
		
		// quicksort(array,pivotIndex+1,right)
		ADDC(quicksort_pivotIndex, 2, quicksort_pivotIndex)
		PUSH(quicksort_right)
		PUSH(quicksort_pivotIndex)
		PUSH(quicksort_array)
		CALL(quicksort)
		POP(quicksort_array)
		POP(quicksort_pivotIndex)
		POP(quicksort_right)	
		
quicksort_end:
		POP(quicksort_pivotIndex)
		POP(quicksort_test)
		POP(quicksort_right)
		POP(quicksort_left)
		POP(quicksort_array)
        MOVE(BP, SP)
        POP(BP)
        POP(LP)
        JMP(LP)

// Allocate a stack: SP is initialized by checkoff code.
StackBasePtr:
        LONG(StackArea)

.unprotect

StackArea:
        STORAGE(1000)
