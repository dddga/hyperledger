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
export PATH=${HOME}/myProject/bin:$PATH
export FABRIC_CFG_PATH=${PWD}/config

CHANNEL_NAME="infinity"


# create channel
infoln "Generating channel create transaction '${CHANNEL_NAME}.tx'"
set -x
configtxgen -profile TwoOrgsChannel -outputCreateChannelTx ./channel-artifacts/${CHANNEL_NAME}.tx -channelID $CHANNEL_NAME
{ set +x; } 2>/dev/null

export ORDERER_CA=${PWD}/organizations/ordererOrganizations/center.com/orderers/orderer.center.com/msp/tlscacerts/tlsca.center.com-cert.pem
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_LOCALMSPID="Org1MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/org1.fortune.infinity/peers/peer0.org1.fortune.infinity/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org1.fortune.infinity/users/Admin@org1.fortune.infinity/msp
export CORE_PEER_ADDRESS=localhost:5011
set -x
peer channel create -o localhost:9999 -c $CHANNEL_NAME --ordererTLSHostnameOverride orderer.center.com -f ./channel-artifacts/${CHANNEL_NAME}.tx --outputBlock ./channel-artifacts/${CHANNEL_NAME}.block --tls --cafile $ORDERER_CA >&log.txt
{ set +x; } 2>/dev/null
cat log.txt


# join channel (peer0.org1.com)
infoln "Joining org1 peer0 to the channel..."
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_LOCALMSPID="Org1MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/org1.fortune.infinity/peers/peer0.org1.fortune.infinity/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org1.fortune.infinity/users/Admin@org1.fortune.infinity/msp
export CORE_PEER_ADDRESS=localhost:5011

set -x
peer channel join -b ./channel-artifacts/${CHANNEL_NAME}.block >&log.txt
{ set +x; } 2>/dev/null
cat log.txt

# join channel (peer1.org1.com)
infoln "Joining org1 peer1 to the channel..."
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_LOCALMSPID="Org1MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/org1.fortune.infinity/peers/peer1.org1.fortune.infinity/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org1.fortune.infinity/users/Admin@org1.fortune.infinity/msp
export CORE_PEER_ADDRESS=localhost:5021

set -x
peer channel join -b ./channel-artifacts/${CHANNEL_NAME}.block >&log.txt
{ set +x; } 2>/dev/null
cat log.txt

# join channel (peer2.org1.com)
infoln "Joining org1 peer2 to the channel..."
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_LOCALMSPID="Org1MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/org1.fortune.infinity/peers/peer2.org1.fortune.infinity/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org1.fortune.infinity/users/Admin@org1.fortune.infinity/msp
export CORE_PEER_ADDRESS=localhost:5031

set -x
peer channel join -b ./channel-artifacts/${CHANNEL_NAME}.block >&log.txt
{ set +x; } 2>/dev/null
cat log.txt

# join channel (peer3.org1.com)
infoln "Joining org1 peer3 to the channel..."
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_LOCALMSPID="Org1MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/org1.fortune.infinity/peers/peer3.org1.fortune.infinity/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org1.fortune.infinity/users/Admin@org1.fortune.infinity/msp
export CORE_PEER_ADDRESS=localhost:5041

set -x
peer channel join -b ./channel-artifacts/${CHANNEL_NAME}.block >&log.txt
{ set +x; } 2>/dev/null
cat log.txt

# join channel (peer0.org2.com)
infoln "Joining org2 peer0 to the channel..."
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_LOCALMSPID="Org2MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/org2.watch.dog/peers/peer0.org2.watch.dog/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org2.watch.dog/users/Admin@org2.watch.dog/msp
export CORE_PEER_ADDRESS=localhost:7011

set -x
peer channel join -b ./channel-artifacts/${CHANNEL_NAME}.block >&log.txt
{ set +x; } 2>/dev/null
cat log.txt

# join channel (peer1.org2.com)
infoln "Joining org2 peer1 to the channel..."
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_LOCALMSPID="Org2MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/org2.watch.dog/peers/peer1.org2.watch.dog/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org2.watch.dog/users/Admin@org2.watch.dog/msp
export CORE_PEER_ADDRESS=localhost:7021

set -x
peer channel join -b ./channel-artifacts/${CHANNEL_NAME}.block >&log.txt
{ set +x; } 2>/dev/null
cat log.txt

# join channel (peer2.org2.com)
infoln "Joining org2 peer2 to the channel..."
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_LOCALMSPID="Org2MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/org2.watch.dog/peers/peer2.org2.watch.dog/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org2.watch.dog/users/Admin@org2.watch.dog/msp
export CORE_PEER_ADDRESS=localhost:7031

set -x
peer channel join -b ./channel-artifacts/${CHANNEL_NAME}.block >&log.txt
{ set +x; } 2>/dev/null
cat log.txt

# join channel (peer3.org2.com)
infoln "Joining org2 peer3 to the channel..."
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_LOCALMSPID="Org2MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/org2.watch.dog/peers/peer3.org2.watch.dog/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org2.watch.dog/users/Admin@org2.watch.dog/msp
export CORE_PEER_ADDRESS=localhost:7041

set -x
peer channel join -b ./channel-artifacts/${CHANNEL_NAME}.block >&log.txt
{ set +x; } 2>/dev/null
cat log.txt

peer channel list