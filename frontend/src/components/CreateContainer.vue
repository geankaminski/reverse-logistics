<template>
  <div>
    <h4>Criar Container</h4>
    <div class="mb-5 mt-3">
      <div class="row p-3 g-3">
        <div class="col-sm">
          <label class="form-label">Nome do Container</label>
          <input class="form-control" type="text" v-model="containerName" />
        </div>

        <div class="col-sm">
          <label class="form-label">Capacidade</label>
          <input class="form-control" type="text" v-model="containerCapacity" />
        </div>

        <div class="col-sm">
          <label class="form-label">Carteira do PEV</label>
          <input class="form-control" type="text" v-model="pevWallet" />
        </div>
      </div>

      <button class="btn btn-primary" @click="createContainer">
        Criar Container
      </button>
    </div>

    <hr />

    <button class="btn btn-primary mt-5" @click="getOwners">
      Listar PEVS com Container
    </button>

    <div class="mt-4 row">
      <div class="col-6">
        <div v-if="ownersList.length" class="p-3">
          <h4 class="mt-4">PEVs</h4>
          <div
            v-for="(owner, index) in ownersList"
            :key="owner + index"
            class="p-2"
          >
            <span class="pointer" @click="getContainers(owner)">{{
              owner
            }}</span>
          </div>
        </div>
      </div>

      <div class="col-6">
        <div v-if="containersList" class="mt-4">
          <h4>Containers do PEV: {{ selectedOwner }}</h4>
          <div
            v-for="(container, index) in containersList"
            :key="container + index"
            class="p-3"
          >
            <span>
              Nome: <span>{{ container.name }}</span
              >,
            </span>
            <span>
              Capacidade: <span>{{ container.capacity }}</span
              >,
            </span>
            <span>
              Quantidade: <span>{{ container.currentAmount }}</span
              >,
            </span>
            <span>
              Status: <span>{{ container.status }}</span>
            </span>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import ReverseLogistics from "../../../blockchain/artifacts/contracts/ReverseLogistics.sol/ReverseLogistics.json";
import { smart_contract_address } from "../contractParams.js";

export default {
  name: "CreateContainer",
  data() {
    return {
      containerName: "",
      containerCapacity: "",
      pevWallet: "",
      contractAddress: smart_contract_address,
      ownersList: [],
      containersList: null,
      selectedOwner: null,
    };
  },
  methods: {
    async searchAccounts() {
      const { ethereum } = window;

      if (!ethereum) {
        alert("Make sure you have metamask!");
        return false;
      } else {
        console.log("We have the ethereum object", ethereum);
      }

      const accounts = await ethereum.request({ method: "eth_accounts" });

      return accounts;
    },
    createContainer: async function () {
      try {
        let accounts = await this.searchAccounts();

        if (accounts.length !== 0) {
          const account = accounts[0];

          console.log("Found an authorized account:", account);

          const provider = new this.$ethers.providers.JsonRpcProvider(
            "http://127.0.0.1:8545"
          );

          const signer = provider.getSigner();

          const contract = new this.$ethers.Contract(
            this.contractAddress,
            ReverseLogistics.abi,
            signer
          );

          let transaction = await contract.createContainer(
            this.containerName,
            this.containerCapacity,
            this.pevWallet
          );

          console.log("Mining...", transaction.hash);
          await transaction.wait();
          console.log("Mined --", transaction.hash);
        } else {
          console.log("No authorized account found");
          return false;
        }

        this.containerName = "";
        this.containerCapacity = "";
        this.pevWallet = "";

        alert("Container criado com sucesso!");
      } catch (error) {
        console.log(error);
        return false;
      }
    },
    getOwners: async function () {
      try {
        let accounts = await this.searchAccounts();

        if (accounts.length !== 0) {
          const account = accounts[0];

          console.log("Found an authorized account:", account);

          const provider = new this.$ethers.providers.JsonRpcProvider(
            "http://127.0.0.1:8545"
          );

          const signer = provider.getSigner();

          const contract = new this.$ethers.Contract(
            this.contractAddress,
            ReverseLogistics.abi,
            signer
          );

          let transaction = await contract.listContainersOwners();

          this.ownersList = transaction.filter(
            (item, index) => transaction.indexOf(item) === index
          );
        } else {
          console.log("No authorized account found");
          return false;
        }
      } catch (error) {
        console.log(error);
        return false;
      }
    },
    async getContainers(owner) {
      try {
        let accounts = await this.searchAccounts();

        if (accounts.length !== 0) {
          const account = accounts[0];

          console.log("Found an authorized account:", account);

          const provider = new this.$ethers.providers.JsonRpcProvider(
            "http://127.0.0.1:8545"
          );

          const signer = provider.getSigner();

          const contract = new this.$ethers.Contract(
            this.contractAddress,
            ReverseLogistics.abi,
            signer
          );

          let transaction = await contract.getContainersByOwner(owner);

          transaction = transaction.filter(
            (item) => item[2] !== "0x0000000000000000000000000000000000000000"
          );

          this.containersList = transaction;

          this.selectedOwner = owner;
        } else {
          console.log("No authorized account found");
          return false;
        }
      } catch (error) {
        console.log(error);
        return false;
      }
    },
  },
};
</script>