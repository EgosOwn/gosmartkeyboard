package auth

import (
	"encoding/base64"
	"golang.org/x/crypto/sha3"
	"os"
	"testing"
)

func TestAuthPasswordHashBad(t *testing.T) {
	os.RemoveAll("test-auth-token")
	os.Setenv("KEYBOARD_AUTH_TOKEN_FILE", "test-auth-token")
	os.WriteFile("test-auth-token", []byte("junk"), 0644)
	t.Log("TestAuthPasswordHash")

	password := "wrong password"

	result := CheckAuthToken(password)
	if result == nil {
		t.Errorf("Expected error, got nil")
	}
	os.RemoveAll("test-auth-token")
}

func TestAuthPasswordEmpty(t *testing.T) {
	os.RemoveAll("test-auth-token")
	os.Setenv("KEYBOARD_AUTH_TOKEN_FILE", "test-auth-token")
	os.WriteFile("test-auth-token", []byte("c0067d4af4e87f00dbac63b6156828237059172d1bbeac67427345d6a9fda484"), 0644)
	t.Log("TestAuthPasswordHash")

	password := ""

	result := CheckAuthToken(password)
	if result == nil {
		t.Errorf("Expected error, got nil")
	}
	os.RemoveAll("test-auth-token")
}

func TestAuthPasswordHashGood(t *testing.T) {
	os.RemoveAll("test-auth-token")
	os.Setenv("KEYBOARD_AUTH_TOKEN_FILE", "test-auth-token")
	//os.WriteFile("test-auth-token", []byte("c0067d4af4e87f00dbac63b6156828237059172d1bbeac67427345d6a9fda484"), 0644)
	expectedHash := sha3.Sum256([]byte("password"))
	fo, err := os.Create("test-auth-token")
	if err != nil {
		panic(err)
	}
	fo.Write(expectedHash[:])
	t.Log("TestAuthPasswordHash")

	password := base64.StdEncoding.EncodeToString([]byte("password"))

	result := CheckAuthToken(password)
	if result != nil {
		t.Errorf("Expected nil, got error")
	}
	os.RemoveAll("test-auth-token")
}
