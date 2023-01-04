# Logística Reversa - Sandbox

## Blockchain

Para rodar, execute os passos abaixo:

1. Na pasta `blockchain`, execute `npm install` para instalar as dependências.

2. Execute `npx hardhat compile` para compilar o contrato.

3. Execute `npx hardhat node` para rodar um nó local.

4. Execute `npx hardhat run scripts/deploy.js --network localhost` em outra aba para fazer o deploy do contrato.


## Frontend

Para rodar, execute os passos abaixo:

1. Crie uma conta no [Infura](https://infura.io/).

2. Crie um novo projeto IPFS no Infura.

3. Crie um subdomínio nas configurações do projeto IPFS.

4. Atualize o arquivo `frontend/src/ipfsParams.js` com as chaves do projeto criado.

5. Atualize o arquivo `frontend/src/contractParams.js` com o endereço do contrato que deve estar rodando em `http://127.0.0.1:8545`.

6. Na pasta `frontend`, execute `npm install` para instalar as dependências.

7. Execute `npm start` para rodar o frontend.


## Observações

É necessário ter o [Metamask](https://metamask.io/) no navegador.