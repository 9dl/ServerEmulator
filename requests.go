package main

import (
	"fmt"
	"net/http"
)

//   w.WriteHeader(http.StatusUnauthorized)
//   fmt.Fprint(w, "This is the /logingithub endpoint.")
//   w.Header().Set("Content-Type", "text/plain")

func handlePublic(w http.ResponseWriter, r *http.Request) {
	fmt.Fprint(w, "9dl/ServerEmulator")
}

func handleLogin(w http.ResponseWriter, r *http.Request) {
	fmt.Fprint(w, "9dl/ServerEmulator")
}
