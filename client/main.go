package main

import (
	"context"
	"flag"
	pb "github.com/i-chi-li/example-go-bazel-protobuf/generated/proto"
	"google.golang.org/grpc"
	"google.golang.org/grpc/credentials/insecure"
	"google.golang.org/protobuf/types/known/anypb"
	"log"
	"time"
)

const (
	defaultName = "world"
)

var (
	addr = flag.String("addr", "localhost:8080", "the address to connect to")
	name = flag.String("name", defaultName, "Name to greet")
)

func main() {
	flag.Parse()
	conn, err := grpc.Dial(*addr, grpc.WithTransportCredentials(insecure.NewCredentials()))
	if err != nil {
		log.Fatalf("did not connect: %v", err)
	}
	defer func() {
		err := conn.Close()
		if err != nil {
			log.Println("can't close", err)
		}
	}()
	c := pb.NewGreeterClient(conn)
	ctx, cancel := context.WithTimeout(context.Background(), time.Second)
	defer cancel()
	t, _ := anypb.New(&pb.Tag{Tag: map[string]string{"FOO": "BAR"}})
	r, err := c.SayHello(ctx, &pb.User{Id: "id", Name: "hoge", Address: &pb.Address{City: "Tokyo"}, Tags: t})
	if err != nil {
		log.Fatalf("could not greet: %v", err)
	}
	log.Printf("Greeting: %s", r.String())
}
