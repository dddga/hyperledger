# DID 기반 추첨
------------------
## 하이퍼레저 네트워크 구성 준비
- ubuntu 22.04.1 사용
- 공식 홈페이지에서 제공하는 fabric-samples 참조 [reference site](https://hyperledger-fabric.readthedocs.io/en/release-2.2/getting_started.html#)  
- 명령어 git curl docker docker-compose golang-go nodejs, jq 설치
- fabric-samples 다운로드

      curl -sSL https://bit.ly/2ysbOFE | bash -s -- 2.2.8 1.5.3  

bin(binary 파일) 파일들과 docker image를 이 프로젝트에서 사용  

-----------------
## 하이퍼레저 네트워크 구성 
### 구성 방법
fabric-ca 네트워크 사용  
- ca - org1, org2, orderer 3개  
- orderer - 1개  
- org1 - peer 4개  
- org2 - peer 4개  
- channel - (org1,org2) 1개  
- chaincode - 1개  

### 구성 파일 정보
<details>
    <summary>구성 파일</summary>

    /config  
    - configtx.yaml - 버전, 정책, 합의알고리즘, 앵커피어, 오더러, 피어, 채널 등 genesis블록 생성을 위한 조건 구성  

    /docker  
    - docker-compose-couch.yaml - 피어당 1개씩 couchdb 구성  
    - docker-compose-net.yaml - orderer, peer 노드 구성  
    - docker-compose-ca.yaml - ca 노드 구성  

    /scripts  
    - registerEnroll.sh - org1, org2의 peer들과 orderer의 CA 등록(인증서, 키 생성)  
    
    /application/ccp  
    - ccp-generate.sh - server와 fabric network 연결  
    
    /application  
    - enrolladmin.js - server의 admin 계정 등록  
    - sever.js  - server 설정  
    
    /chaincode-go/fortune-chaincode  
    - fortuneInfinity.go - 체인코드 정의  
</details>

    curl -sSL https://bit.ly/2ysbOFE | bash -s -- 2.2.8 1.5.3  

-------------------
## 작동 순서
- 시작  

      cd hyperledger  
      ./startnetwork.sh  
      ./createchannel.sh  
      ./setAnchorPeerUpdate.sh  
      ./deployCC.sh  
      cd application/ccp  
      ./ccp-generate.sh  
      cd ..  
      node enrolladmin.js  
      node server.js  
- 종료  

      cd hyperledger
      ./networkdown.sh
      
웹사이트 접속 : https://localhost:3000  
couchdb 접속 : https://localhost:5501/_utils (모든 peer의 couchdb포트 가능)  
(id : admin, pw: adminpw)
