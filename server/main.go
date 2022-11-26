package main

import (
	"context"
	pb "github.com/i-chi-li/example-go-bazel-protobuf/generated/proto"
	"google.golang.org/grpc"
	"google.golang.org/protobuf/types/known/anypb"
	"log"
	"net"
)

const (
	port = ":8080"
)

type server struct{}

func (s *server) SayHello(_ context.Context, in *pb.User) (*pb.User, error) {
	log.Printf("User: %v", in)
	t, _ := anypb.New(&pb.Tag{Tag: map[string]string{"foo": "bar"}})
	return &pb.User{Id: "1", Name: in.Name, Address: &pb.Address{City: "tokyo"}, Tags: t}, nil
}

func main() {
	lis, err := net.Listen("tcp", port)
	if err != nil {
		log.Fatal(err)
	}

	s := grpc.NewServer()
	pb.RegisterGreeterServer(s, &server{})
	err = s.Serve(lis)
	if err != nil {
		log.Fatal(err)
	}
}
