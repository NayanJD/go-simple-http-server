package main

import (
	"log/slog"
	"net/http"
	"os"
)

func main() {
	http.HandleFunc("/hello", func(w http.ResponseWriter, r *http.Request) {

		logger.Info("received request")
		defer logger.Info("handled request")

		w.Header().Add("Content-Type", "application/json")
		w.WriteHeader(http.StatusOK)
		w.Write([]byte(`{ "message": "hi!" }`))
	})

	slog.Info("Listening on 0.0.0.0:9000")
	if err := http.ListenAndServe("0.0.0.0:9000", http.DefaultServeMux); err != nil {
		slog.Error("Error while serving server", "err", err)
		os.Exit(1)
	}
}
