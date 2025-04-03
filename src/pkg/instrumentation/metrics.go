package instrumentation

import (
	"github.com/prometheus/client_golang/prometheus"
)

var InFlightGauge = prometheus.NewGauge(prometheus.GaugeOpts{
	Name: "http_in_flight_requests",
	Help: "A gauge of requests currently being served by the wrapped handler.",
})

var Counter = prometheus.NewCounterVec(
	prometheus.CounterOpts{
		Name: "http_api_requests_total",
		Help: "A counter for requests to the wrapped handler.",
	},
	[]string{"code", "method"},
)

// duration is partitioned by the HTTP method and handler. It uses custom
// buckets based on the expected request duration.
var Duration = prometheus.NewHistogramVec(
	prometheus.HistogramOpts{
		Name:    "http_request_duration_seconds",
		Help:    "A histogram of latencies for requests.",
		Buckets: []float64{.25, .5, 1, 2.5, 5, 10},
	},
	[]string{"handler", "method"},
)

// responseSize has no labels, making it a zero-dimensional
// ObserverVec.
var ResponseSize = prometheus.NewHistogramVec(
	prometheus.HistogramOpts{
		Name:    "http_response_size_bytes",
		Help:    "A histogram of response sizes for requests.",
		Buckets: []float64{200, 500, 900, 1500},
	},
	[]string{},
)

func Init() {
	prometheus.MustRegister(InFlightGauge, Counter, Duration, ResponseSize)
}
