package main

import (
	"encoding/json"
	"crypto/sha256"
	"fmt"

	"github.com/hyperledger/fabric-contract-api-go/contractapi"
)

// SmartContract provides functions for managing an Asset
type SmartContract struct {
	contractapi.Contract
}

// Asset describes basic details of what makes up a simple asset
type User struct {
	DrawName  string `json:"drawname"`
	DID       string `json:"did"`
	RandomNum int    `json:"randnum"`
	Timestamp int    `json:"timestamp"`
	Maker	  bool	 `json:"maker"`
}

type AllQueryResult struct{
	Key string	`json:"key"`
	Value *User
}


// InitLedger adds a base set of assets to the ledger
func (s *SmartContract) InitLedger(ctx contractapi.TransactionContextInterface) error {
	testusers := []User{
		{DrawName: "nike-sneakers", DID: "DID-FUNCTION-EIJNGWEOQSGALDSNIB-HASH", RandomNum: 1565767536, Timestamp: 785676565, Maker: true},
		{DrawName: "nike-sneakers2", DID: "DID-FUNCTION-EIJNGWEOQSGALDSNIB-HASH2", RandomNum: 15657675362, Timestamp: 7856765652, Maker: true},
	}

	for _, user := range testusers {
		hash := sha256.Sum256([]byte(user.DrawName+user.DID))
		hashstring := fmt.Sprintf("%x", hash)
		testuserJSON, err := json.Marshal(user)
		if err != nil {
			return err
		}
		err = ctx.GetStub().PutState(hashstring, testuserJSON)
		if err != nil {
			return fmt.Errorf("failed to put to world state. %v", err)
		}
	}

	return nil
}

// CreateAsset issues a new asset to the world state with given details.
func (s *SmartContract) CreateDraw(ctx contractapi.TransactionContextInterface, drawnamedid string, drawname string, did string, randnum int, timestamp int, maker bool) error {
	drawExists, err := s.MyDrawExists(ctx, drawnamedid)
	if err != nil {
		return err
	}
	if drawExists {
		return fmt.Errorf("your draw %s already exists", drawname)
	}

	user := User{
		drawname,
		did,
		randnum,
		timestamp,
		maker,
	}
	userJSON, err := json.Marshal(user)
	if err != nil {
		return err
	}

	return ctx.GetStub().PutState(drawnamedid, userJSON)
}

// ReadAsset returns the asset stored in the world state with given id.
func (s *SmartContract) ConfirmDraw(ctx contractapi.TransactionContextInterface, drawnamedid string) (*User, error) {
	drawJSON, err := ctx.GetStub().GetState(drawnamedid)
	if err != nil {
		return nil, fmt.Errorf("failed to read from world state: %v", err)
	}
	if drawJSON == nil {
		return nil, nil
	}

	var user User
	err = json.Unmarshal(drawJSON, &user)
	if err != nil {
		return nil, err
	}

	return &user, nil
}

// DeleteAsset deletes an given asset from the world state.
func (s *SmartContract) DeleteDraw(ctx contractapi.TransactionContextInterface, drawnamedid string) (bool, error) {
	drawexists, err := s.MyDrawExists(ctx, drawnamedid)
	if err != nil {
		return false, err
	}
	if !drawexists {
		return false,nil
	}
	err = ctx.GetStub().DelState(drawnamedid)
	return true, err
}

// DrawExists returns true when asset with given ID exists in world state
func (s *SmartContract) MyDrawExists(ctx contractapi.TransactionContextInterface, drawnamedid string) (bool, error) {
	drawJSON, err := ctx.GetStub().GetState(drawnamedid)
	if err != nil {
		return false, fmt.Errorf("failed to read from world state: %v", err)
	}

	return drawJSON != nil, nil
}

func (s *SmartContract) AllDrawQuery(ctx contractapi.TransactionContextInterface) ([]AllQueryResult, error){
	allquerys, err := ctx.GetStub().GetStateByRange("", "")
	if err != nil{
		return nil, err
	}
	defer allquerys.Close()

	results := []AllQueryResult{}

	for allquerys.HasNext(){
		queryResponse, err := allquerys.Next()

		if err != nil {
			return nil, err
		}

		user := new(User)
		err = json.Unmarshal(queryResponse.Value, user)
		if err != nil{
			return nil, err
		}
		queryResult := AllQueryResult{Key: queryResponse.Key, Value: user}
		results = append(results, queryResult)
	}
	return results, nil
}

func (s *SmartContract) FindDraw(ctx contractapi.TransactionContextInterface, drawname string) (bool, error){
	queries, err := s.AllDrawQuery(ctx)
	if err!= nil{
		fmt.Println(err)
		return false, err
	}
	for _,j := range queries{
		if j.Value.DrawName == drawname{
			return true, nil
		}
	}
	return false, nil
}


func main() {
	chaincode, err := contractapi.NewChaincode(new(SmartContract))

	if err != nil {
		fmt.Printf("Error1 create fortune chaincode: %s", err.Error())
		return
	}

	if err := chaincode.Start(); err != nil {
		fmt.Printf("Error2 starting fortune chaincode: %s", err.Error())
	}
}
