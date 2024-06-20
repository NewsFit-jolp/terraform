# terraform
인프라를 구성하는 테라폼 레포지토리입니다.

## Architecture

<img width="663" alt="Diagram" src="https://github.com/NewsFit-jolp/terraform/assets/76674422/7604b085-8dca-459e-973f-916dd6c7bd4c">

- 서비스 시스템 설계안
- 추천 시스템은 머신러닝을 기반으로 하기 때문에 컴퓨팅 리소스가 많이 필요합니다. 따라서 온프레미스 환경에 이를 구축하여 사용할 것입니다. 서버와의 연결은 Site-to-Site VPN 연결 또는 매뉴얼한 IPsec 통신을 통해 연결을 구축할 예정입니다. 이는 필요에 따라 L7 암호화를 통한 통신으로 변경될 수 있습니다.
- 웹 애플리케이션 서버는 3-tier architecture 구조를 가지고 있습니다. AWS의 Code시리즈를 통한 CICD로 Private한 환경에 CICD를 구축할 수 있었습니다.
- 웹 크롤링 서비스는 서버리스 서비스를 적극적으로 이용하였습니다. URL을 먼저 가져온 후 DynamoDB에 저장하여 중복 URL을 제거합니다. 이후 비동기적으로 이벤트를 폴링하여 크롤링을 진행하고 S3 bucket에 뉴스 데이터를 저장합니다. 이후 뉴스 데이터를 통해 이벤트를 트리거한 람다가 LangChain을 기반하여 카테고라이징 및 서머라이징을 진행하고 가공된 데이터를 다시 한 번 S3 bucket에 저장합니다. 이후 Web Application Server가 해당 데이터를 소비합니다.
