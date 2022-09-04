#!/bin/bash

C_YELLOW='\033[1;33m'
C_BLUE='\033[0;34m'
C_RESET='\033[0m'

# subinfoln echos in blue color
function infoln() {
  echo -e "${C_YELLOW}${1}${C_RESET}"
}

function subinfoln() {
  echo -e "${C_BLUE}${1}${C_RESET}"
}

# add PATH to ensure we are picking up the correct binaries
export PATH=${HOME}/hyperledger/bin:$PATH
export FABRIC_CFG_PATH=${PWD}/config

# Chaincode config variable

# CHANNEL_NAME="mychannel"
CC_NAME="fortuneInfinity"
CC_SRC_PATH="./chaincode-go/fortune-chaincode"
CC_RUNTIME_LANGUAGE="golang"
CC_VERSION="1"
CHANNEL_NAME="infinity"


## package the chaincode
infoln "Packaging chaincode"
set -x
peer lifecycle chaincode package ${CC_NAME}.tar.gz --path ${CC_SRC_PATH} --lang ${CC_RUNTIME_LANGUAGE} --label ${CC_NAME}_${CC_VERSION} >&log.txt
{ set +x; } 2>/dev/null
cat log.txt

## Install chaincode on peer0.org1
infoln "Installing chaincode on peer0.org1..."

export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_LOCALMSPID="Org1MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/org1.fortune.infinity/peers/peer0.org1.fortune.infinity/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org1.fortune.infinity/users/Admin@org1.fortune.infinity/msp
export CORE_PEER_ADDRESS=localhost:5011

set -x
peer lifecycle chaincode install ${CC_NAME}.tar.gz >&log.txt
{ set +x; } 2>/dev/null
cat log.txt

## Install chaincode on peer1.org1
infoln "Installing chaincode on peer1.org1..."

export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_LOCALMSPID="Org1MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/org1.fortune.infinity/peers/peer1.org1.fortune.infinity/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org1.fortune.infinity/users/Admin@org1.fortune.infinity/msp
export CORE_PEER_ADDRESS=localhost:5021

set -x
peer lifecycle chaincode install ${CC_NAME}.tar.gz >&log.txt
{ set +x; } 2>/dev/null
cat log.txt

## Install chaincode on peer2.org1
infoln "Installing chaincode on peer2.org1..."

export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_LOCALMSPID="Org1MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/org1.fortune.infinity/peers/peer2.org1.fortune.infinity/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org1.fortune.infinity/users/Admin@org1.fortune.infinity/msp
export CORE_PEER_ADDRESS=localhost:5031

set -x
peer lifecycle chaincode install ${CC_NAME}.tar.gz >&log.txt
{ set +x; } 2>/dev/null
cat log.txt

## Install chaincode on peer3.org1
infoln "Installing chaincode on peer3.org1..."

export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_LOCALMSPID="Org1MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/org1.fortune.infinity/peers/peer3.org1.fortune.infinity/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org1.fortune.infinity/users/Admin@org1.fortune.infinity/msp
export CORE_PEER_ADDRESS=localhost:5041

set -x
peer lifecycle chaincode install ${CC_NAME}.tar.gz >&log.txt
{ set +x; } 2>/dev/null
cat log.txt


## Install chaincode on peer0.org2
infoln "Installing chaincode on peer0.org2..."

export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_LOCALMSPID="Org2MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/org2.watch.dog/peers/peer0.org2.watch.dog/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org2.watch.dog/users/Admin@org2.watch.dog/msp
export CORE_PEER_ADDRESS=localhost:7011

set -x
peer lifecycle chaincode install ${CC_NAME}.tar.gz >&log.txt
{ set +x; } 2>/dev/null
cat log.txt

## Install chaincode on peer1.org2
infoln "Installing chaincode on peer1.org2..."

export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_LOCALMSPID="Org2MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/org2.watch.dog/peers/peer1.org2.watch.dog/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org2.watch.dog/users/Admin@org2.watch.dog/msp
export CORE_PEER_ADDRESS=localhost:7021

set -x
peer lifecycle chaincode install ${CC_NAME}.tar.gz >&log.txt
{ set +x; } 2>/dev/null
cat log.txt
## Install chaincode on peer2.org2
infoln "Installing chaincode on peer2.org2..."

export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_LOCALMSPID="Org2MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/org2.watch.dog/peers/peer2.org2.watch.dog/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org2.watch.dog/users/Admin@org2.watch.dog/msp
export CORE_PEER_ADDRESS=localhost:7031

set -x
peer lifecycle chaincode install ${CC_NAME}.tar.gz >&log.txt
{ set +x; } 2>/dev/null
cat log.txt
## Install chaincode on peer3.org2
infoln "Installing chaincode on peer3.org2..."

export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_LOCALMSPID="Org2MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/org2.watch.dog/peers/peer3.org2.watch.dog/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org2.watch.dog/users/Admin@org2.watch.dog/msp
export CORE_PEER_ADDRESS=localhost:7041

set -x
peer lifecycle chaincode install ${CC_NAME}.tar.gz >&log.txt
{ set +x; } 2>/dev/null
cat log.txt



## approve the definition for org1
infoln "approve the definition on peer0.org1..."

ORDERER_CA=${PWD}/organizations/ordererOrganizations/center.com/orderers/orderer.center.com/msp/tlscacerts/tlsca.center.com-cert.pem

export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_LOCALMSPID="Org1MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/org1.fortune.infinity/peers/peer0.org1.fortune.infinity/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org1.fortune.infinity/users/Admin@org1.fortune.infinity/msp
export CORE_PEER_ADDRESS=localhost:5011

set -x
peer lifecycle chaincode queryinstalled >&log.txt  
{ set +x; } 2>/dev/null
PACKAGE_ID=$(sed -n "/${CC_NAME}_${CC_VERSION}/{s/^Package ID: //; s/, Label:.*$//; p;}" log.txt)

set -x
peer lifecycle chaincode approveformyorg -o localhost:9999 --ordererTLSHostnameOverride orderer.center.com  --tls --cafile $ORDERER_CA --channelID $CHANNEL_NAME --name ${CC_NAME} --version ${CC_VERSION} --package-id ${PACKAGE_ID} --sequence 1 >&log.txt
{ set +x; } 2>/dev/null
cat log.txt

## check commitreadiness
peer lifecycle chaincode checkcommitreadiness --channelID $CHANNEL_NAME  --name ${CC_NAME} --version ${CC_VERSION} --sequence 1 --tls --cafile $ORDERER_CA --output json


## commit the chaincode definition
infoln "commit the chaincode definition"

PEER_CONN_PARMS="
--peerAddresses localhost:5011 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/org1.fortune.infinity/peers/peer0.org1.fortune.infinity/tls/ca.crt 
--peerAddresses localhost:7011 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/org2.watch.dog/peers/peer0.org2.watch.dog/tls/ca.crt
"


## approve the definition for org2
infoln "approve the definition on peer0.org2..."

ORDERER_CA=${PWD}/organizations/ordererOrganizations/center.com/orderers/orderer.center.com/msp/tlscacerts/tlsca.center.com-cert.pem

export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_LOCALMSPID="Org2MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/org2.watch.dog/peers/peer0.org2.watch.dog/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org2.watch.dog/users/Admin@org2.watch.dog/msp
export CORE_PEER_ADDRESS=localhost:7011

set -x
peer lifecycle chaincode queryinstalled >&log.txt  
{ set +x; } 2>/dev/null
PACKAGE_ID=$(sed -n "/${CC_NAME}_${CC_VERSION}/{s/^Package ID: //; s/, Label:.*$//; p;}" log.txt)

set -x
peer lifecycle chaincode approveformyorg -o localhost:9999 --ordererTLSHostnameOverride orderer.center.com  --tls --cafile $ORDERER_CA --channelID $CHANNEL_NAME --name ${CC_NAME} --version ${CC_VERSION} --package-id ${PACKAGE_ID} --sequence 1 >&log.txt
{ set +x; } 2>/dev/null
cat log.txt

## check commitreadiness
peer lifecycle chaincode checkcommitreadiness --channelID $CHANNEL_NAME  --name ${CC_NAME} --version ${CC_VERSION} --sequence 1 --tls --cafile $ORDERER_CA --output json

set -x
peer lifecycle chaincode commit -o localhost:9999 --ordererTLSHostnameOverride orderer.center.com  --tls --cafile $ORDERER_CA --channelID $CHANNEL_NAME --name ${CC_NAME} $PEER_CONN_PARMS --version ${CC_VERSION} --sequence 1 >&log.txt
{ set +x; } 2>/dev/null
cat log.txt

peer lifecycle chaincode querycommitted --channelID $CHANNEL_NAME --name ${CC_NAME} --cafile $ORDERER_CA


#TEST1 : Invoking the chaincode
infoln "TEST1 : Invoking the chaincode"
set -x
peer chaincode invoke -o localhost:9999 --ordererTLSHostnameOverride orderer.center.com --tls --cafile $ORDERER_CA -C $CHANNEL_NAME -n ${CC_NAME} $PEER_CONN_PARMS -c '{"function":"InitLedger","Args":[]}' >&log.txt
{ set +x; } 2>/dev/null
cat log.txt
sleep 3

# #TEST2 : Query the chaincode
infoln "TEST2 : Query the chaincode"
set -x
peer chaincode query -C $CHANNEL_NAME -n ${CC_NAME} -c '{"Args":["AllDrawQuery"]}' >&log.txt
{ set +x; } 2>/dev/null
cat log.txt
