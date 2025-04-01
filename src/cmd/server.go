package main

import (
	"log/slog"
	"net/http"
	"os"
	"runtime"

	_ "net/http/pprof"
)

func main() {

	runtime.GOMAXPROCS(runtime.NumCPU())

	mux := http.NewServeMux()

	mux.HandleFunc("/hello", func(w http.ResponseWriter, r *http.Request) {

		// logger := slog.With("component", "server")

		// logger.Info("received request")
		// defer logger.Info("handled request")

		w.Header().Add("Content-Type", "application/json")
		w.WriteHeader(http.StatusOK)
		w.Write([]byte(`{ "message": "hi!" }`))
	})

	server := &http.Server{
		Addr:    ":9000",
		Handler: mux,
		// MaxHeaderBytes:    1 << 20,
		// IdleTimeout:       0, // Prevent idle connections from blocking
		// ReadHeaderTimeout: 0, // Prevent slow readers from blocking
	}

	slog.Info("Listening on 0.0.0.0:9000")
	if err := server.ListenAndServe(); err != nil {
		slog.Error("Error while serving server", "err", err)
		os.Exit(1)
	}
}
