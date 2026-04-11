package thefarm

import (
	"errors"
	"fmt"
)

func DivideFood(fc FodderCalculator, cows int) (float64, error) {
	if fa, err := fc.FodderAmount(cows); err != nil {
		return 0, err
	} else if ff, err := fc.FatteningFactor(); err != nil {
		return 0, err
	} else {
		return fa / float64(cows) * ff, nil
	}
}

func ValidateInputAndDivideFood(fc FodderCalculator, cows int) (float64, error) {
	if cows <= 0 {
		return 0, errors.New("invalid number of cows")
	} else {
		return DivideFood(fc, cows)
	}
}

type InvalidCowsError struct {
	cows    int
	message string
}

func (e *InvalidCowsError) Error() string {
	return fmt.Sprintf("%d cows are invalid: %s", e.cows, e.message)
}

func ValidateNumberOfCows(cows int) error {
	if cows < 0 {
		return new(InvalidCowsError{cows: cows, message: "there are no negative cows"})
	} else if cows == 0 {
		return new(InvalidCowsError{cows: cows, message: "no cows don't need food"})
	} else {
		return nil
	}
}
