package main

import (
	"crypto/tls"
	"fmt"
	"log"
	"net/http"
)

func main() {
	port := 80
	useSSL := false
	sslCertificateFile := "CertificateBypass.pfx"

	router := NewRouter()

	// Define routes and handlers
	router.HandleFunc("/public", handlePublic)
	router.HandleFunc("/login", handleLogin)

	go startServer(port, useSSL, sslCertificateFile, router)

	select {}
}

func startServer(port int, useSSL bool, sslCertificateFile string, router *Router) {
	server := &http.Server{
		Addr:    fmt.Sprintf(":%d", port),
		Handler: router,
	}

	if useSSL {
		port = 443
	}

	if useSSL {
		tlsConfig, err := configureTLS(sslCertificateFile)
		if err != nil {
			log.Fatalf("Error configuring TLS: %v", err)
		}
		server.TLSConfig = tlsConfig
	}

	if useSSL {
		log.Printf("Server is listening on port %d with SSL...\n", port)
		err := server.ListenAndServeTLS("", "")
		if err != nil {
			log.Fatalf("Error starting server: %v", err)
		}
	} else {
		log.Printf("Server is listening on port %d...\n", port)
		err := server.ListenAndServe()
		if err != nil {
			log.Fatalf("Error starting server: %v", err)
		}
	}
}

func configureTLS(sslCertificateFile string) (*tls.Config, error) {
	if sslCertificateFile == "" {
		return nil, nil
	}

	cert, err := tls.LoadX509KeyPair(sslCertificateFile, sslCertificateFile)
	if err != nil {
		return nil, err
	}

	tlsConfig := &tls.Config{
		Certificates: []tls.Certificate{cert},
	}

	return tlsConfig, nil
}
