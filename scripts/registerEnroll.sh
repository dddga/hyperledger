#!/bin/bash

function createOrg1() {
  subinfoln "Enrolling the CA admin"
  mkdir -p organizations/peerOrganizations/org1.fortune.infinity/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/org1.fortune.infinity/

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:5550 --caname ca-org1 --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-5550-ca-org1.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-5550-ca-org1.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-5550-ca-org1.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-5550-ca-org1.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/organizations/peerOrganizations/org1.fortune.infinity/msp/config.yaml

  subinfoln "Registering peer0"
  set -x
  fabric-ca-client register --caname ca-org1 --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem
  { set +x; } 2>/dev/null

  subinfoln "Registering peer1"
  set -x
  fabric-ca-client register --caname ca-org1 --id.name peer1 --id.secret peer1pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem
  { set +x; } 2>/dev/null

  subinfoln "Registering peer2"
  set -x
  fabric-ca-client register --caname ca-org1 --id.name peer2 --id.secret peer2pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem
  { set +x; } 2>/dev/null

  subinfoln "Registering peer3"
  set -x
  fabric-ca-client register --caname ca-org1 --id.name peer3 --id.secret peer3pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem
  { set +x; } 2>/dev/null

  subinfoln "Registering user"
  set -x
  fabric-ca-client register --caname ca-org1 --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem
  { set +x; } 2>/dev/null

  subinfoln "Registering the org admin"
  set -x
  fabric-ca-client register --caname ca-org1 --id.name org1admin --id.secret org1adminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem
  { set +x; } 2>/dev/null

  subinfoln "Generating the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:5550 --caname ca-org1 -M ${PWD}/organizations/peerOrganizations/org1.fortune.infinity/peers/peer0.org1.fortune.infinity/msp --csr.hosts peer0.org1.fortune.infinity --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/org1.fortune.infinity/msp/config.yaml ${PWD}/organizations/peerOrganizations/org1.fortune.infinity/peers/peer0.org1.fortune.infinity/msp/config.yaml

  subinfoln "Generating the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:5550 --caname ca-org1 -M ${PWD}/organizations/peerOrganizations/org1.fortune.infinity/peers/peer0.org1.fortune.infinity/tls --enrollment.profile tls --csr.hosts peer0.org1.fortune.infinity --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/org1.fortune.infinity/peers/peer0.org1.fortune.infinity/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org1.fortune.infinity/peers/peer0.org1.fortune.infinity/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/org1.fortune.infinity/peers/peer0.org1.fortune.infinity/tls/signcerts/* ${PWD}/organizations/peerOrganizations/org1.fortune.infinity/peers/peer0.org1.fortune.infinity/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/org1.fortune.infinity/peers/peer0.org1.fortune.infinity/tls/keystore/* ${PWD}/organizations/peerOrganizations/org1.fortune.infinity/peers/peer0.org1.fortune.infinity/tls/server.key

  mkdir -p ${PWD}/organizations/peerOrganizations/org1.fortune.infinity/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/org1.fortune.infinity/peers/peer0.org1.fortune.infinity/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org1.fortune.infinity/msp/tlscacerts/ca.crt

  mkdir -p ${PWD}/organizations/peerOrganizations/org1.fortune.infinity/tlsca
  cp ${PWD}/organizations/peerOrganizations/org1.fortune.infinity/peers/peer0.org1.fortune.infinity/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org1.fortune.infinity/tlsca/tlsca.org1.fortune.infinity-cert.pem

  mkdir -p ${PWD}/organizations/peerOrganizations/org1.fortune.infinity/ca
  cp ${PWD}/organizations/peerOrganizations/org1.fortune.infinity/peers/peer0.org1.fortune.infinity/msp/cacerts/* ${PWD}/organizations/peerOrganizations/org1.fortune.infinity/ca/ca.org1.fortune.infinity-cert.pem

  subinfoln "Generating the peer1 msp"
  set -x
  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:5550 --caname ca-org1 -M ${PWD}/organizations/peerOrganizations/org1.fortune.infinity/peers/peer1.org1.fortune.infinity/msp --csr.hosts peer1.org1.fortune.infinity --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/org1.fortune.infinity/msp/config.yaml ${PWD}/organizations/peerOrganizations/org1.fortune.infinity/peers/peer1.org1.fortune.infinity/msp/config.yaml

  subinfoln "Generating the peer1-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:5550 --caname ca-org1 -M ${PWD}/organizations/peerOrganizations/org1.fortune.infinity/peers/peer1.org1.fortune.infinity/tls --enrollment.profile tls --csr.hosts peer1.org1.fortune.infinity --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/org1.fortune.infinity/peers/peer1.org1.fortune.infinity/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org1.fortune.infinity/peers/peer1.org1.fortune.infinity/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/org1.fortune.infinity/peers/peer1.org1.fortune.infinity/tls/signcerts/* ${PWD}/organizations/peerOrganizations/org1.fortune.infinity/peers/peer1.org1.fortune.infinity/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/org1.fortune.infinity/peers/peer1.org1.fortune.infinity/tls/keystore/* ${PWD}/organizations/peerOrganizations/org1.fortune.infinity/peers/peer1.org1.fortune.infinity/tls/server.key

  mkdir -p ${PWD}/organizations/peerOrganizations/org1.fortune.infinity/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/org1.fortune.infinity/peers/peer1.org1.fortune.infinity/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org1.fortune.infinity/msp/tlscacerts/ca.crt

  mkdir -p ${PWD}/organizations/peerOrganizations/org1.fortune.infinity/tlsca
  cp ${PWD}/organizations/peerOrganizations/org1.fortune.infinity/peers/peer1.org1.fortune.infinity/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org1.fortune.infinity/tlsca/tlsca.org1.fortune.infinity-cert.pem

  mkdir -p ${PWD}/organizations/peerOrganizations/org1.fortune.infinity/ca
  cp ${PWD}/organizations/peerOrganizations/org1.fortune.infinity/peers/peer1.org1.fortune.infinity/msp/cacerts/* ${PWD}/organizations/peerOrganizations/org1.fortune.infinity/ca/ca.org1.fortune.infinity-cert.pem

  subinfoln "Generating the peer2 msp"
  set -x
  fabric-ca-client enroll -u https://peer2:peer2pw@localhost:5550 --caname ca-org1 -M ${PWD}/organizations/peerOrganizations/org1.fortune.infinity/peers/peer2.org1.fortune.infinity/msp --csr.hosts peer2.org1.fortune.infinity --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/org1.fortune.infinity/msp/config.yaml ${PWD}/organizations/peerOrganizations/org1.fortune.infinity/peers/peer2.org1.fortune.infinity/msp/config.yaml

  subinfoln "Generating the peer2-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer2:peer2pw@localhost:5550 --caname ca-org1 -M ${PWD}/organizations/peerOrganizations/org1.fortune.infinity/peers/peer2.org1.fortune.infinity/tls --enrollment.profile tls --csr.hosts peer2.org1.fortune.infinity --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/org1.fortune.infinity/peers/peer2.org1.fortune.infinity/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org1.fortune.infinity/peers/peer2.org1.fortune.infinity/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/org1.fortune.infinity/peers/peer2.org1.fortune.infinity/tls/signcerts/* ${PWD}/organizations/peerOrganizations/org1.fortune.infinity/peers/peer2.org1.fortune.infinity/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/org1.fortune.infinity/peers/peer2.org1.fortune.infinity/tls/keystore/* ${PWD}/organizations/peerOrganizations/org1.fortune.infinity/peers/peer2.org1.fortune.infinity/tls/server.key

  mkdir -p ${PWD}/organizations/peerOrganizations/org1.fortune.infinity/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/org1.fortune.infinity/peers/peer2.org1.fortune.infinity/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org1.fortune.infinity/msp/tlscacerts/ca.crt

  mkdir -p ${PWD}/organizations/peerOrganizations/org1.fortune.infinity/tlsca
  cp ${PWD}/organizations/peerOrganizations/org1.fortune.infinity/peers/peer2.org1.fortune.infinity/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org1.fortune.infinity/tlsca/tlsca.org1.fortune.infinity-cert.pem

  mkdir -p ${PWD}/organizations/peerOrganizations/org1.fortune.infinity/ca
  cp ${PWD}/organizations/peerOrganizations/org1.fortune.infinity/peers/peer2.org1.fortune.infinity/msp/cacerts/* ${PWD}/organizations/peerOrganizations/org1.fortune.infinity/ca/ca.org1.fortune.infinity-cert.pem

  subinfoln "Generating the peer3 msp"
  set -x
  fabric-ca-client enroll -u https://peer3:peer3pw@localhost:5550 --caname ca-org1 -M ${PWD}/organizations/peerOrganizations/org1.fortune.infinity/peers/peer3.org1.fortune.infinity/msp --csr.hosts peer3.org1.fortune.infinity --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/org1.fortune.infinity/msp/config.yaml ${PWD}/organizations/peerOrganizations/org1.fortune.infinity/peers/peer3.org1.fortune.infinity/msp/config.yaml

  subinfoln "Generating the peer3-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer3:peer3pw@localhost:5550 --caname ca-org1 -M ${PWD}/organizations/peerOrganizations/org1.fortune.infinity/peers/peer3.org1.fortune.infinity/tls --enrollment.profile tls --csr.hosts peer3.org1.fortune.infinity --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/org1.fortune.infinity/peers/peer3.org1.fortune.infinity/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org1.fortune.infinity/peers/peer3.org1.fortune.infinity/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/org1.fortune.infinity/peers/peer3.org1.fortune.infinity/tls/signcerts/* ${PWD}/organizations/peerOrganizations/org1.fortune.infinity/peers/peer3.org1.fortune.infinity/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/org1.fortune.infinity/peers/peer3.org1.fortune.infinity/tls/keystore/* ${PWD}/organizations/peerOrganizations/org1.fortune.infinity/peers/peer3.org1.fortune.infinity/tls/server.key

  mkdir -p ${PWD}/organizations/peerOrganizations/org1.fortune.infinity/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/org1.fortune.infinity/peers/peer3.org1.fortune.infinity/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org1.fortune.infinity/msp/tlscacerts/ca.crt

  mkdir -p ${PWD}/organizations/peerOrganizations/org1.fortune.infinity/tlsca
  cp ${PWD}/organizations/peerOrganizations/org1.fortune.infinity/peers/peer3.org1.fortune.infinity/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org1.fortune.infinity/tlsca/tlsca.org1.fortune.infinity-cert.pem

  mkdir -p ${PWD}/organizations/peerOrganizations/org1.fortune.infinity/ca
  cp ${PWD}/organizations/peerOrganizations/org1.fortune.infinity/peers/peer3.org1.fortune.infinity/msp/cacerts/* ${PWD}/organizations/peerOrganizations/org1.fortune.infinity/ca/ca.org1.fortune.infinity-cert.pem

  subinfoln "Generating the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:5550 --caname ca-org1 -M ${PWD}/organizations/peerOrganizations/org1.fortune.infinity/users/User1@org1.fortune.infinity/msp --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/org1.fortune.infinity/msp/config.yaml ${PWD}/organizations/peerOrganizations/org1.fortune.infinity/users/User1@org1.fortune.infinity/msp/config.yaml

  subinfoln "Generating the org admin msp"
  set -x
  fabric-ca-client enroll -u https://org1admin:org1adminpw@localhost:5550 --caname ca-org1 -M ${PWD}/organizations/peerOrganizations/org1.fortune.infinity/users/Admin@org1.fortune.infinity/msp --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/org1.fortune.infinity/msp/config.yaml ${PWD}/organizations/peerOrganizations/org1.fortune.infinity/users/Admin@org1.fortune.infinity/msp/config.yaml
}

function createOrg2() {
  subinfoln "Enrolling the CA admin"
  mkdir -p organizations/peerOrganizations/org2.watch.dog/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/org2.watch.dog/

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:7770 --caname ca-org2 --tls.certfiles ${PWD}/organizations/fabric-ca/org2/tls-cert.pem
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-7770-ca-org2.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-7770-ca-org2.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-7770-ca-org2.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-7770-ca-org2.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/organizations/peerOrganizations/org2.watch.dog/msp/config.yaml

  subinfoln "Registering peer0"
  set -x
  fabric-ca-client register --caname ca-org2 --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/org2/tls-cert.pem
  { set +x; } 2>/dev/null

  subinfoln "Registering peer1"
  set -x
  fabric-ca-client register --caname ca-org2 --id.name peer1 --id.secret peer1pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/org2/tls-cert.pem
  { set +x; } 2>/dev/null

  subinfoln "Registering peer2"
  set -x
  fabric-ca-client register --caname ca-org2 --id.name peer2 --id.secret peer2pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/org2/tls-cert.pem
  { set +x; } 2>/dev/null

  subinfoln "Registering peer3"
  set -x
  fabric-ca-client register --caname ca-org2 --id.name peer3 --id.secret peer3pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/org2/tls-cert.pem
  { set +x; } 2>/dev/null

  subinfoln "Registering user"
  set -x
  fabric-ca-client register --caname ca-org2 --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/organizations/fabric-ca/org2/tls-cert.pem
  { set +x; } 2>/dev/null

  subinfoln "Registering the org admin"
  set -x
  fabric-ca-client register --caname ca-org2 --id.name org2admin --id.secret org2adminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/org2/tls-cert.pem
  { set +x; } 2>/dev/null

  subinfoln "Generating the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7770 --caname ca-org2 -M ${PWD}/organizations/peerOrganizations/org2.watch.dog/peers/peer0.org2.watch.dog/msp --csr.hosts peer0.org2.watch.dog --tls.certfiles ${PWD}/organizations/fabric-ca/org2/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/org2.watch.dog/msp/config.yaml ${PWD}/organizations/peerOrganizations/org2.watch.dog/peers/peer0.org2.watch.dog/msp/config.yaml

  subinfoln "Generating the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7770 --caname ca-org2 -M ${PWD}/organizations/peerOrganizations/org2.watch.dog/peers/peer0.org2.watch.dog/tls --enrollment.profile tls --csr.hosts peer0.org2.watch.dog --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/org2/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/org2.watch.dog/peers/peer0.org2.watch.dog/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org2.watch.dog/peers/peer0.org2.watch.dog/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/org2.watch.dog/peers/peer0.org2.watch.dog/tls/signcerts/* ${PWD}/organizations/peerOrganizations/org2.watch.dog/peers/peer0.org2.watch.dog/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/org2.watch.dog/peers/peer0.org2.watch.dog/tls/keystore/* ${PWD}/organizations/peerOrganizations/org2.watch.dog/peers/peer0.org2.watch.dog/tls/server.key

  mkdir -p ${PWD}/organizations/peerOrganizations/org2.watch.dog/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/org2.watch.dog/peers/peer0.org2.watch.dog/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org2.watch.dog/msp/tlscacerts/ca.crt

  mkdir -p ${PWD}/organizations/peerOrganizations/org2.watch.dog/tlsca
  cp ${PWD}/organizations/peerOrganizations/org2.watch.dog/peers/peer0.org2.watch.dog/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org2.watch.dog/tlsca/tlsca.org2.watch.dog-cert.pem

  mkdir -p ${PWD}/organizations/peerOrganizations/org2.watch.dog/ca
  cp ${PWD}/organizations/peerOrganizations/org2.watch.dog/peers/peer0.org2.watch.dog/msp/cacerts/* ${PWD}/organizations/peerOrganizations/org2.watch.dog/ca/ca.org2.watch.dog-cert.pem

  subinfoln "Generating the peer1 msp"
  set -x
  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:7770 --caname ca-org2 -M ${PWD}/organizations/peerOrganizations/org2.watch.dog/peers/peer1.org2.watch.dog/msp --csr.hosts peer1.org2.watch.dog --tls.certfiles ${PWD}/organizations/fabric-ca/org2/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/org2.watch.dog/msp/config.yaml ${PWD}/organizations/peerOrganizations/org2.watch.dog/peers/peer1.org2.watch.dog/msp/config.yaml

  subinfoln "Generating the peer1-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:7770 --caname ca-org2 -M ${PWD}/organizations/peerOrganizations/org2.watch.dog/peers/peer1.org2.watch.dog/tls --enrollment.profile tls --csr.hosts peer1.org2.watch.dog --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/org2/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/org2.watch.dog/peers/peer1.org2.watch.dog/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org2.watch.dog/peers/peer1.org2.watch.dog/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/org2.watch.dog/peers/peer1.org2.watch.dog/tls/signcerts/* ${PWD}/organizations/peerOrganizations/org2.watch.dog/peers/peer1.org2.watch.dog/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/org2.watch.dog/peers/peer1.org2.watch.dog/tls/keystore/* ${PWD}/organizations/peerOrganizations/org2.watch.dog/peers/peer1.org2.watch.dog/tls/server.key

  mkdir -p ${PWD}/organizations/peerOrganizations/org2.watch.dog/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/org2.watch.dog/peers/peer1.org2.watch.dog/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org2.watch.dog/msp/tlscacerts/ca.crt

  mkdir -p ${PWD}/organizations/peerOrganizations/org2.watch.dog/tlsca
  cp ${PWD}/organizations/peerOrganizations/org2.watch.dog/peers/peer1.org2.watch.dog/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org2.watch.dog/tlsca/tlsca.org2.watch.dog-cert.pem

  mkdir -p ${PWD}/organizations/peerOrganizations/org2.watch.dog/ca
  cp ${PWD}/organizations/peerOrganizations/org2.watch.dog/peers/peer1.org2.watch.dog/msp/cacerts/* ${PWD}/organizations/peerOrganizations/org2.watch.dog/ca/ca.org2.watch.dog-cert.pem

  subinfoln "Generating the peer2 msp"
  set -x
  fabric-ca-client enroll -u https://peer2:peer2pw@localhost:7770 --caname ca-org2 -M ${PWD}/organizations/peerOrganizations/org2.watch.dog/peers/peer2.org2.watch.dog/msp --csr.hosts peer2.org2.watch.dog --tls.certfiles ${PWD}/organizations/fabric-ca/org2/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/org2.watch.dog/msp/config.yaml ${PWD}/organizations/peerOrganizations/org2.watch.dog/peers/peer2.org2.watch.dog/msp/config.yaml

  subinfoln "Generating the peer2-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer2:peer2pw@localhost:7770 --caname ca-org2 -M ${PWD}/organizations/peerOrganizations/org2.watch.dog/peers/peer2.org2.watch.dog/tls --enrollment.profile tls --csr.hosts peer2.org2.watch.dog --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/org2/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/org2.watch.dog/peers/peer2.org2.watch.dog/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org2.watch.dog/peers/peer2.org2.watch.dog/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/org2.watch.dog/peers/peer2.org2.watch.dog/tls/signcerts/* ${PWD}/organizations/peerOrganizations/org2.watch.dog/peers/peer2.org2.watch.dog/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/org2.watch.dog/peers/peer2.org2.watch.dog/tls/keystore/* ${PWD}/organizations/peerOrganizations/org2.watch.dog/peers/peer2.org2.watch.dog/tls/server.key

  mkdir -p ${PWD}/organizations/peerOrganizations/org2.watch.dog/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/org2.watch.dog/peers/peer2.org2.watch.dog/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org2.watch.dog/msp/tlscacerts/ca.crt

  mkdir -p ${PWD}/organizations/peerOrganizations/org2.watch.dog/tlsca
  cp ${PWD}/organizations/peerOrganizations/org2.watch.dog/peers/peer2.org2.watch.dog/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org2.watch.dog/tlsca/tlsca.org2.watch.dog-cert.pem

  mkdir -p ${PWD}/organizations/peerOrganizations/org2.watch.dog/ca
  cp ${PWD}/organizations/peerOrganizations/org2.watch.dog/peers/peer2.org2.watch.dog/msp/cacerts/* ${PWD}/organizations/peerOrganizations/org2.watch.dog/ca/ca.org2.watch.dog-cert.pem

  subinfoln "Generating the peer3 msp"
  set -x
  fabric-ca-client enroll -u https://peer3:peer3pw@localhost:7770 --caname ca-org2 -M ${PWD}/organizations/peerOrganizations/org2.watch.dog/peers/peer3.org2.watch.dog/msp --csr.hosts peer3.org2.watch.dog --tls.certfiles ${PWD}/organizations/fabric-ca/org2/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/org2.watch.dog/msp/config.yaml ${PWD}/organizations/peerOrganizations/org2.watch.dog/peers/peer3.org2.watch.dog/msp/config.yaml

  subinfoln "Generating the peer3-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer3:peer3pw@localhost:7770 --caname ca-org2 -M ${PWD}/organizations/peerOrganizations/org2.watch.dog/peers/peer3.org2.watch.dog/tls --enrollment.profile tls --csr.hosts peer3.org2.watch.dog --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/org2/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/org2.watch.dog/peers/peer3.org2.watch.dog/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org2.watch.dog/peers/peer3.org2.watch.dog/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/org2.watch.dog/peers/peer3.org2.watch.dog/tls/signcerts/* ${PWD}/organizations/peerOrganizations/org2.watch.dog/peers/peer3.org2.watch.dog/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/org2.watch.dog/peers/peer3.org2.watch.dog/tls/keystore/* ${PWD}/organizations/peerOrganizations/org2.watch.dog/peers/peer3.org2.watch.dog/tls/server.key

  mkdir -p ${PWD}/organizations/peerOrganizations/org2.watch.dog/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/org2.watch.dog/peers/peer3.org2.watch.dog/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org2.watch.dog/msp/tlscacerts/ca.crt

  mkdir -p ${PWD}/organizations/peerOrganizations/org2.watch.dog/tlsca
  cp ${PWD}/organizations/peerOrganizations/org2.watch.dog/peers/peer3.org2.watch.dog/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org2.watch.dog/tlsca/tlsca.org2.watch.dog-cert.pem

  mkdir -p ${PWD}/organizations/peerOrganizations/org2.watch.dog/ca
  cp ${PWD}/organizations/peerOrganizations/org2.watch.dog/peers/peer3.org2.watch.dog/msp/cacerts/* ${PWD}/organizations/peerOrganizations/org2.watch.dog/ca/ca.org2.watch.dog-cert.pem

  subinfoln "Generating the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:7770 --caname ca-org2 -M ${PWD}/organizations/peerOrganizations/org2.watch.dog/users/User1@org2.watch.dog/msp --tls.certfiles ${PWD}/organizations/fabric-ca/org2/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/org2.watch.dog/msp/config.yaml ${PWD}/organizations/peerOrganizations/org2.watch.dog/users/User1@org2.watch.dog/msp/config.yaml

  subinfoln "Generating the org admin msp"
  set -x
  fabric-ca-client enroll -u https://org2admin:org2adminpw@localhost:7770 --caname ca-org2 -M ${PWD}/organizations/peerOrganizations/org2.watch.dog/users/Admin@org2.watch.dog/msp --tls.certfiles ${PWD}/organizations/fabric-ca/org2/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/org2.watch.dog/msp/config.yaml ${PWD}/organizations/peerOrganizations/org2.watch.dog/users/Admin@org2.watch.dog/msp/config.yaml
}

function createOrderer() {
  subinfoln "Enrolling the CA admin"
  mkdir -p organizations/ordererOrganizations/center.com

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/ordererOrganizations/center.com

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:9990 --caname ca-orderer --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-9990-ca-orderer.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-9990-ca-orderer.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-9990-ca-orderer.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-9990-ca-orderer.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/organizations/ordererOrganizations/center.com/msp/config.yaml

  subinfoln "Registering orderer"
  set -x
  fabric-ca-client register --caname ca-orderer --id.name orderer --id.secret ordererpw --id.type orderer --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  subinfoln "Registering the orderer admin"
  set -x
  fabric-ca-client register --caname ca-orderer --id.name ordererAdmin --id.secret ordererAdminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  subinfoln "Generating the orderer msp"
  set -x
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:9990 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/center.com/orderers/orderer.center.com/msp --csr.hosts orderer.center.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/ordererOrganizations/center.com/msp/config.yaml ${PWD}/organizations/ordererOrganizations/center.com/orderers/orderer.center.com/msp/config.yaml

  subinfoln "Generating the orderer-tls certificates"
  set -x
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:9990 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/center.com/orderers/orderer.center.com/tls --enrollment.profile tls --csr.hosts orderer.center.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/ordererOrganizations/center.com/orderers/orderer.center.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/center.com/orderers/orderer.center.com/tls/ca.crt
  cp ${PWD}/organizations/ordererOrganizations/center.com/orderers/orderer.center.com/tls/signcerts/* ${PWD}/organizations/ordererOrganizations/center.com/orderers/orderer.center.com/tls/server.crt
  cp ${PWD}/organizations/ordererOrganizations/center.com/orderers/orderer.center.com/tls/keystore/* ${PWD}/organizations/ordererOrganizations/center.com/orderers/orderer.center.com/tls/server.key

  mkdir -p ${PWD}/organizations/ordererOrganizations/center.com/orderers/orderer.center.com/msp/tlscacerts
  cp ${PWD}/organizations/ordererOrganizations/center.com/orderers/orderer.center.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/center.com/orderers/orderer.center.com/msp/tlscacerts/tlsca.center.com-cert.pem

  mkdir -p ${PWD}/organizations/ordererOrganizations/center.com/msp/tlscacerts
  cp ${PWD}/organizations/ordererOrganizations/center.com/orderers/orderer.center.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/center.com/msp/tlscacerts/tlsca.center.com-cert.pem

  subinfoln "Generating the admin msp"
  set -x
  fabric-ca-client enroll -u https://ordererAdmin:ordererAdminpw@localhost:9990 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/center.com/users/Admin@center.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/ordererOrganizations/center.com/msp/config.yaml ${PWD}/organizations/ordererOrganizations/center.com/users/Admin@center.com/msp/config.yaml
}