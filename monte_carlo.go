package main

import (
	"fmt"
	"math/rand"
	"strings"
	"time"

	"gonum.org/v1/gonum/stat"
	"gonum.org/v1/gonum/stat/distuv"
)

type StateValue struct {
	State string
	Value float64
}

func monteCarloSimulation(stateValues []StateValue, numSimulations int) []float64 {
	// Create normal distribution with mean and standard deviation
	normalDist := distuv.Normal{
		Mu:    955.96,
		Sigma: 365,
	}

	simulatedRentPrices := make([]float64, numSimulations)
	for i := 0; i < numSimulations; i++ {
		randomIndex := rand.Intn(len(stateValues))
		randomStateValue := stateValues[randomIndex]
		simulatedRentPrices[i] = normalDist.Rand() * randomStateValue.Value
	}

	return simulatedRentPrices
}

func main() {

	data := `AK    0.691069
	AL    0.630696
	AR    0.573385
	AZ    0.734274
	CA    1.616430
	CO    1.019437
	CT    0.829511
	DC    1.457015
	DE    0.756996
	FL    1.031060
	GA    0.886445
	HI    1.788955
	IA    0.622854
	ID    0.735670
	IL    0.974057
	IN    0.666749
	KS    0.602349
	KY    0.649861
	LA    0.671738
	MA    1.437158
	MD    1.076854
	ME    0.819907
	MI    0.785315
	MN    0.910817
	MO    0.687290
	MS    0.573001
	MT    0.731436
	NC    0.755685
	ND    0.620274
	NE    0.611799
	NH    0.953126
	NJ    1.335770
	NM    0.553260
	NV    0.769179
	NY    1.659419
	OH    0.728085
	OK    0.667427
	OR    0.967080
	PA    0.851524
	RI    1.333743
	SC    0.749471
	SD    0.581845
	TN    0.771376
	TX    0.798868
	UT    0.852562
	VA    0.973839
	VT    0.927569
	WA    1.197644
	WI    0.807256
	WV    0.571435
	WY    0.518983`

	var stateValues []StateValue
	lines := strings.Split(data, "\n")
	for _, line := range lines {
		var state string
		var value float64
		fmt.Sscanf(line, "%s %f", &state, &value)
		stateValues = append(stateValues, StateValue{State: state, Value: value})
	}

	const num_runs = 100
	executionTimes := make([]float64, num_runs)

	for i := 0; i < num_runs; i++ {
		startTime := time.Now()

		//simulatedRentPrices := monteCarloSimulation(stateValues, 10000)
		_ = monteCarloSimulation(stateValues, 10000)

		endTime := time.Now()
		executionTimes[i] = endTime.Sub(startTime).Seconds()
	}

	mean_time, stddev_time := stat.MeanStdDev(executionTimes, nil)
	max_time := executionTimes[0]
	for _, t := range executionTimes {
		if t > max_time {
			max_time = t
		}
	}

	fmt.Printf("Mean Execution Time: %.4f seconds\n", mean_time)
	fmt.Printf("Standard Deviation of Execution Time: %.4f seconds\n", stddev_time)
	fmt.Printf("Maximum Execution Time: %.4f seconds\n", max_time)

}
