<template>
  <div id="app">
    <div class="mb-4 d-flex justify-content-center align-items-center header">
      <router-link class="p-3 link" to="/containers">Containers</router-link>
      <router-link class="p-3 link" to="/delivery">Entrega</router-link>
      <router-link class="p-3 link" to="/collect">Coleta</router-link>
    </div>

    <router-view />
  </div>
</template>

<script>
export default {
  name: "App",
};
</script>

<style>
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
}

.pointer {
  cursor: pointer;
}

.header {
  background-color: #2c3e50;
  color: white;
}

.link {
  color: white;
  text-decoration: none;
}
</style>
