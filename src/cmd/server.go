package main

import (
	"log/slog"
	"net/http"
	"os"
	"runtime"

	_ "net/http/pprof"

	"simplehttp/src/pkg/instrumentation"

	"github.com/prometheus/client_golang/prometheus"
	"github.com/prometheus/client_golang/prometheus/promhttp"
)

func main() {

	runtime.GOMAXPROCS(runtime.NumCPU())

	prometheus.MustRegister(instrumentation.InFlightGauge, instrumentation.Counter, instrumentation.Duration, instrumentation.ResponseSize)

	mux := http.NewServeMux()

	handleHello := promhttp.InstrumentHandlerInFlight(instrumentation.InFlightGauge,
		promhttp.InstrumentHandlerDuration(instrumentation.Duration.MustCurryWith(prometheus.Labels{"handler": "hello"}),
			promhttp.InstrumentHandlerCounter(instrumentation.Counter,
				promhttp.InstrumentHandlerResponseSize(instrumentation.ResponseSize,
					http.HandlerFunc(HandleHello),
				),
			),
		),
	)

	mux.Handle("/hello", handleHello)

	mux.Handle("/metrics", promhttp.Handler())

	server := &http.Server{
		Addr:              ":9000",
		Handler:           mux,
		MaxHeaderBytes:    1 << 20,
		IdleTimeout:       0, // Prevent idle connections from blocking
		ReadHeaderTimeout: 0, // Prevent slow readers from blocking
	}

	slog.Info("Listening on 0.0.0.0:9000")
	if err := server.ListenAndServe(); err != nil {
		slog.Error("Error while serving server", "err", err)
		os.Exit(1)
	}
}

func HandleHello(w http.ResponseWriter, r *http.Request) {

	// logger := slog.With("component", "server")

	// logger.Info("received request")
	// defer logger.Info("handled request")

	w.Header().Add("Content-Type", "application/json")
	w.WriteHeader(http.StatusOK)
	w.Write([]byte(`{ "message": "hi!" }`))
}

func InstrumentHandlerFunc(h http.HandlerFunc) http.HandlerFunc {

	requestCounter := prometheus.NewCounterVec(prometheus.CounterOpts{
		Name: "http_request_count",
		Help: "No of request counter",
	}, []string{"code", "method", "handler"})

	prometheus.MustRegister(requestCounter)

	h = promhttp.InstrumentHandlerCounter(requestCounter, h)

	return h
}
