package godot_event

import (
	"encoding/json"
	"errors"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/service/dynamodb"
	"github.com/aws/aws-sdk-go/service/dynamodb/dynamodbattribute"
	"github.com/aws/aws-sdk-go/service/dynamodb/dynamodbiface"
)

var (
	ErrorFailedToUnmarshalRecord = "failed to unmarshal record"
	ErrorFailedToFetchRecord     = "failed to fetch record"
	ErrorInvalidEventData        = "invalid Event data"
	ErrorInvalidEmail            = "invalid email"
	ErrorCouldNotMarshalItem     = "could not marshal item"
	ErrorCouldNotDeleteItem      = "could not delete item"
	ErrorCouldNotDynamoPutItem   = "could not dynamo put item error"
	ErrorEventAlreadyExists      = "Event.Event already exists"
	ErrorEventDoesNotExists      = "Event.Event does not exist"
)

// Example of request body for testing:
// {
// 	"EventID": "123"
// "DeviceID": "123",
// "type": "123",
// "MousePos": "123",
// "KeyboardPos": "123",
// "Timestamp": "123"
// }

type GodotEvent struct {
	EventID     string `json:"EventID"`
	DeviceID    string `json:"DeviceID"`
	Type        string `json:"type"`
	MousePos    string `json:"MousePos"`
	KeyboardPos string `json:"KeyboardPos"`
	Timestamp   string `json:"Timestamp"`
}

func CreateEvent(request events.APIGatewayProxyRequest, tableName string, dynaClient dynamodbiface.DynamoDBAPI) (
	*GodotEvent,
	error,
) {
	var ev GodotEvent
	if err := json.Unmarshal([]byte(request.Body), &ev); err != nil {
		return nil, errors.New(ErrorInvalidEventData)
	}

	// Check if Event exists
	// currentEvent, _ := FetchEvent(ev.Email, tableName, dynaClient)
	// if currentEvent != nil && len(currentEvent.Email) != 0 {
	// 	return nil, errors.New(ErrorEventAlreadyExists)
	// }
	// Save GodotEvent
	av, err := dynamodbattribute.MarshalMap(ev)
	if err != nil {
		return nil, errors.New(ErrorCouldNotMarshalItem)
	}

	input := &dynamodb.PutItemInput{
		Item:      av,
		TableName: aws.String(tableName),
	}

	_, err = dynaClient.PutItem(input)
	if err != nil {
		return nil, errors.New(ErrorCouldNotDynamoPutItem)
	}
	return &ev, nil
}
