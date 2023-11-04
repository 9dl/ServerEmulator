package main

import "net/http"

type Router struct {
	mux *http.ServeMux
}

func NewRouter() *Router {
	return &Router{
		mux: http.NewServeMux(),
	}
}

func (r *Router) HandleFunc(path string, handler http.HandlerFunc) {
	r.mux.HandleFunc(path, handler)
}

func (r *Router) ServeHTTP(w http.ResponseWriter, req *http.Request) {
	r.mux.ServeHTTP(w, req)
}
