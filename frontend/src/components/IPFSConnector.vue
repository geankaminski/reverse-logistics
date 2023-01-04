<template>
  <div>
    <form
      class="mt-2 mb-2 d-flex align-items-center justify-content-center"
      @submit="onSubmitHandler"
    >
      <div>
        <input name="file" type="file" />
      </div>

      <button type="submit" class="btn btn-primary">
        Salvar imagem no IFPS
      </button>
    </form>
  </div>
</template>

<script>
import { create } from "ipfs-http-client";

import {
  infura_project_id,
  infura_project_secret,
  infura_project_gateway,
} from "../ipfsParams.js";
const authorization =
  "Basic " + btoa(infura_project_id + ":" + infura_project_secret);

export default {
  name: "IPFSConnector",
  data() {
    return {
      images: [],
      ipfs: null,
    };
  },
  mounted() {
    try {
      this.ipfs = create({
        url: "https://ipfs.infura.io:5001/api/v0",
        headers: {
          authorization,
        },
      });
    } catch (error) {
      console.error("IPFS error ", error);
      this.ipfs = undefined;
    }
  },
  methods: {
    async onSubmitHandler(event) {
      event.preventDefault();

      const form = event.target;
      const files = form[0].files;

      if (!files || files.length === 0) {
        return alert("No files selected");
      }

      const file = files[0];
      const result = await this.ipfs.add(file);

      this.$emit("ipfs-url", infura_project_gateway + result.path);

      alert("Imagem salva no IPFS com sucesso!");

      form.reset();
    },
  },
};
</script>

<style>
</style>