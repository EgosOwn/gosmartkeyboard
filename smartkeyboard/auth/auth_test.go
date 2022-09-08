package main

import (
	"testing"
)

func TestAuthPasswordHashBad(t *testing.T) {
	t.Log("TestAuthPasswordHash")
	expectedResult := error(nil) // OK
	password := "wrong password"

	result := checkAuthToken(password)
	if result != expectedResult {
		t.Errorf("Expected %s, got %s", expectedResult, result)
	}
}
