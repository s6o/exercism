package lasagnamaster

func PreparationTime(layers []string, averagePrep int) int {
	defaultPrepTime := 2
	if averagePrep <= 0 {
		return len(layers) * defaultPrepTime
	} else {
		return len(layers) * averagePrep
	}
}

func Quantities(layers []string) (noodles int, sauce float64) {
	noodles, sauce = 0, 0.0
	for _, layer := range layers {
		if layer == "noodles" {
			noodles += 50
		}
		if layer == "sauce" {
			sauce += 0.2
		}
	}
	return
}

func AddSecretIngredient(friends, my []string) {
	my[len(my)-1] = friends[len(friends)-1]
}

func ScaleRecipe(quantities []float64, people int) []float64 {
	var scaled []float64
	for i := range quantities {
		portion := quantities[i] / 2
		scaled = append(scaled, portion*float64(people))
	}
	return scaled
}
