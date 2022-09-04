# DID 기반 추첨

## 하이퍼레저 네트워크 구성 준비
공식 홈페이지에서 제공하는 fabric-samples 참조 [reference site](https://hyperledger-fabric.readthedocs.io/en/release-2.2/getting_started.html#)  
명령어 git curl docker docker-compose 설치 후

    curl -sSL https://bit.ly/2ysbOFE | bash -s -- 2.2.8 1.5.3  

fabric-samples에서 bin(binary 파일)폴더와 docker image 사용  
<br>

## 하이퍼레저 네트워크 구성 
### 구성 요소
fabric-ca 네트워크 사용  
- ca - org1, org2, orderer 3개  
- orderer - 1개  
- org1 - peer 4개  
- org2 - peer 4개  
- channel - (org1,org2)  
- chaincode - 1개  
  
### 구성 파일
/config  
- configtx.yaml - 버전, 정책, 합의알고리즘, 앵커피어, 오더러, 피어, 채널 등 genesis블록 생성을 위한 조건 구성  
  
/docker  
- docker-compose-couch.yaml - 피어당 1개씩 couchdb 구성  
- docker-compose-net.yaml - orderer, peer 노드 구성  
- docker-compose-ca.yaml - ca 노드 구성  
  
/scripts  
- registerEnroll.sh - org1, org2의 peer들과 orderer의 CA 등록(인증서, 키 생성)  

