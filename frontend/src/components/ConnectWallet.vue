<template>
  <div class="p-3 pt-0">
    <h3>Logística Reversa</h3>
    <div v-if="!currentAccount" class="mt-3 mb-4">
      <button class="btn btn-primary" @click="connectWallet">Conectar</button>
    </div>
    <div v-else class="mt-3 mb-4">Conectado!</div>
  </div>
</template>

<script>
import { smart_contract_address } from "../contractParams.js";

export default {
  name: "ConnectWallet",
  data() {
    return {
      currentAccount: null,
      currentContract: null,
      contractAddress: smart_contract_address,
    };
  },
  mounted() {
    this.checkConnectedWalletExist();
  },
  methods: {
    checkConnectedWalletExist: async function () {
      try {
        const { ethereum } = window;

        if (!ethereum) {
          alert("Make sure you have metamask!");
          return false;
        } else {
          console.log("We have the ethereum object", ethereum);
        }

        const accounts = await ethereum.request({ method: "eth_accounts" });

        if (accounts.length !== 0) {
          const account = accounts[0];

          console.log("Found an authorized account:", account);
          this.currentAccount = account;

          return true;
        } else {
          console.log("No authorized account found");
          return false;
        }
      } catch (error) {
        console.log(error);
        return false;
      }
    },
    connectWallet: async function () {
      try {
        const { ethereum } = window;

        if (!ethereum) {
          alert("Get MetaMask!");
          return;
        }

        const accounts = await ethereum.request({
          method: "eth_requestAccounts",
        });

        console.log("Connected", accounts[0]);
        this.currentAccount = accounts[0];
      } catch (error) {
        console.log(error);
      }
    },
  },
};
</script>

<style scoped>
h3 {
  margin: 40px 0 0;
}

ul {
  list-style-type: none;
  padding: 0;
}

li {
  display: inline-block;
  margin: 0 10px;
}

a {
  color: #42b983;
}
</style>
