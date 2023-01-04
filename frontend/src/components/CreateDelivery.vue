<template>
  <div>
    <h4>Criar Entrega</h4>
    <div class="mb-5 mt-3">
      <div class="row p-3 g-3">
        <div class="col-sm">
          <label class="form-label">Carteira do AMA</label>
          <input class="form-control" type="text" v-model="userWallet" />
        </div>

        <div class="col-sm">
          <label class="form-label">Container</label>
          <select
            class="form-select"
            aria-label="Default select"
            v-model="selectedContainer"
          >
            <option selected>Selecione o container</option>
            <option v-for="container in containers" :key="container.id">
              {{ container.id + " - " + container.name }}
            </option>
          </select>
        </div>

        <div class="col-sm">
          <label class="form-label">Quantidade medida</label>
          <input class="form-control" type="number" v-model="amount" />
        </div>

        <div>
          <IPFSConnector @ipfs-url="urlGenerated" />
        </div>
      </div>

      <button class="btn btn-primary" @click="createDelivery">Entregar</button>
    </div>

    <hr />

    <div class="mt-4 row p-3">
      <div class="col-6">
        <h4>Buscar entregas por Container</h4>

        <div class="mt-3 mb-3">
          <label class="form-label">Container</label>
          <select
            class="form-select"
            aria-label="Default select"
            v-model="searchableContainer"
          >
            <option selected>Selecione o container</option>
            <option v-for="container in containers" :key="container.id">
              {{ container.id + " - " + container.name }}
            </option>
          </select>
        </div>

        <button class="btn btn-primary" @click="getDeliveries">
          Buscar entregas
        </button>
      </div>

      <div class="col-6">
        <div v-if="deliveries.length">
          <h4>Entregas do Container: {{ searchableContainer }}</h4>
          <div
            v-for="(delivery, index) in deliveries"
            :key="delivery + index"
            class="p-3"
          >
            <div>
              <span>
                <span class="font-weight-bold">AMA</span>:
                <span>{{ delivery.from }}</span
                >,
              </span>
              <span>
                <span class="font-weight-bold">Quantidade</span>:
                <span>{{ delivery.confirmedAmount }}</span
                >,
              </span>
              <span>
                <span class="font-weight-bold">Status:</span>
                <span>{{ delivery.status }}</span
                >,
              </span>
              <span>
                <span class="font-weight-bold">URL IPFS:</span>
                <span>{{ delivery.ifpsUrl }}</span>
              </span>
            </div>
            <div class="m-3">
              <img alt="" :src="delivery.ifpsUrl" width="300" />
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
  
<script>
import ReverseLogistics from "../../../blockchain/artifacts/contracts/ReverseLogistics.sol/ReverseLogistics.json";
import { smart_contract_address } from "../contractParams.js";

import IPFSConnector from "./IPFSConnector.vue";

export default {
  name: "CreateDelivery",
  async mounted() {
    await this.getContainers();
  },
  components: {
    IPFSConnector,
  },
  data() {
    return {
      userWallet: "",
      amount: 0,
      description: "",
      ipfsUrl: "",
      selectedContainer: null,
      contractAddress: smart_contract_address,
      containers: [],
      searchableContainer: null,
      deliveries: [],
    };
  },
  methods: {
    selectContainer(container) {
      console.log(container);
    },
    urlGenerated(url) {
      this.ipfsUrl = url;
    },
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
    createDelivery: async function () {
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

          let containerId = this.selectedContainer.split(" - ")[0];

          let transaction = await contract.createDelivery(
            this.userWallet,
            containerId,
            this.amount,
            this.description,
            this.ipfsUrl
          );

          console.log("Mining...", transaction.hash);
          await transaction.wait();
          console.log("Mined --", transaction.hash);
        } else {
          console.log("No authorized account found");
          return false;
        }

        this.userWallet = "";
        this.amount = 0;
        this.description = "";
        this.ipfsUrl = "";
        this.selectedContainer = null;

        alert("Entrega criada com sucesso!");
      } catch (error) {
        console.log(error);
        return false;
      }
    },
    async getContainers() {
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

          let transaction = await contract.getAllContainers();

          this.containers = transaction;
        } else {
          console.log("No authorized account found");
          return false;
        }
      } catch (error) {
        console.log(error);
        return false;
      }
    },
    async getDeliveries() {
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

          let containerId = this.searchableContainer.split(" - ")[0];

          let transaction = await contract.getAllDeliveriesFromContainer(
            containerId
          );

          this.deliveries = transaction.filter(
            (delivery) =>
              delivery.from !== "0x0000000000000000000000000000000000000000"
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
  },
};
</script>

<style scoped>
.font-weight-bold {
  font-weight: bold;
}
</style>