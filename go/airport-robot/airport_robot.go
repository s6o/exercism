package airportrobot

import "fmt"

type Greeter interface {
	LanguageName() string
	Greet(name string) string
}

type Italian struct {
	language string
}

type Portuguese struct {
	language string
}

func SayHello(name string, g Greeter) string {
	return fmt.Sprintf("I can speak %s: %s", g.LanguageName(), g.Greet(name))
}

func (r Italian) LanguageName() string {
	return "Italian"
}

func (r Italian) Greet(name string) string {
	return fmt.Sprintf("Ciao %s!", name)
}

func (r Portuguese) LanguageName() string {
	return "Portuguese"
}

func (r Portuguese) Greet(name string) string {
	return fmt.Sprintf("Olá %s!", name)
}
