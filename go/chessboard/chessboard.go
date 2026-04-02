package chessboard

import "unsafe"

type File []bool
type Chessboard map[string]File

// https://dev.to/chigbeef_77/bool-int-but-stupid-in-go-3jb3
func toZeroOrOne(b bool) int {
	return int(*(*byte)(unsafe.Pointer(&b)))
}

// CountInFile returns how many squares are occupied in the chessboard,
// within the given file.
func CountInFile(cb Chessboard, file string) int {
	count := 0
	for _, square := range cb[file] {
		count += toZeroOrOne(square)
	}
	return count
}

// CountInRank returns how many squares are occupied in the chessboard,
// within the given rank.
func CountInRank(cb Chessboard, rank int) int {
	if rank < 1 || rank > 8 {
		return 0
	}
	count := 0
	for _, file := range cb {
		count += toZeroOrOne(file[rank-1])
	}
	return count
}

// CountAll should count how many squares are present in the chessboard.
func CountAll(cb Chessboard) int {
	count := 0
	for _, file := range cb {
		count += len(file)
	}
	return count
}

// CountOccupied returns how many squares are occupied in the chessboard.
func CountOccupied(cb Chessboard) int {
	count := 0
	for k := range cb {
		count += CountInFile(cb, k)
	}
	return count
}
