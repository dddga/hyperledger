#!/bin/bash

function one_line_pem {
    echo "`awk 'NF {sub(/\\n/, ""); printf "%s\\\\\\\n",$0;}' $1`"
}

function json_ccp {
    local PP=$(one_line_pem $8)
    local CP=$(one_line_pem $9)
    sed -e "s/\${ORG}/$1/" \
        -e "s/\${P0PORT}/$2/" \
        -e "s/\${P1PORT}/$3/" \
        -e "s/\${P2PORT}/$4/" \
        -e "s/\${P3PORT}/$5/" \
        -e "s/\${CAPORT}/$6/" \
        -e "s/\${DOMAIN}/$7/" \
        -e "s#\${PEERPEM}#$PP#" \
        -e "s#\${CAPEM}#$CP#" \
        ${DIR}/ccp-template.json
}

# function yaml_ccp {
#     local PP=$(one_line_pem $4)
#     local CP=$(one_line_pem $5)
#     sed -e "s/\${ORG}/$1/" \
#         -e "s/\${P0PORT}/$2/" \
#         -e "s/\${CAPORT}/$3/" \        
#         -e "s#\${PEERPEM}#$PP#" \
#         -e "s#\${CAPEM}#$CP#" \
#         ${DIR}/ccp-template.yaml | sed -e $'s/\\\\n/\\\n          /g'
# }

# Where am I?
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

NET_DIR_PATH="${HOME}/hyperledger"

ORG=1
P0PORT=5011
P1PORT=5021
P2PORT=5031
P3PORT=5041
CAPORT=5550
DOMAIN="fortune.infinity"
PEERPEM=${NET_DIR_PATH}/organizations/peerOrganizations/org1.fortune.infinity/tlsca/tlsca.org1.fortune.infinity-cert.pem
CAPEM=${NET_DIR_PATH}/organizations/peerOrganizations/org1.fortune.infinity/ca/ca.org1.fortune.infinity-cert.pem

echo "$(json_ccp $ORG $P0PORT $P1PORT $P2PORT $P3PORT $CAPORT $DOMAIN $PEERPEM $CAPEM)" > ${DIR}/connection-org1.json
# echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > ${DIR}/connection-org1.yaml

# ORG=2
# P0PORT=7011
# CAPORT=7770
# PEERPEM=${NET_DIR_PATH}/organizations/peerOrganizations/org2.watch.dog/tlsca/tlsca.org2.watch.dog-cert.pem
# CAPEM=${NET_DIR_PATH}/organizations/peerOrganizations/org2.watch.dog/ca/ca.org2.watch.dog-cert.pem

# echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > ${DIR}/connection-org2.json
# # echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > ${DIR}/connection-org2.yaml
