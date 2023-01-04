import { createApp } from 'vue';
import { ethers } from "ethers";
import App from './App.vue';
import router from './router' 

const app = createApp(App).use(router);
app.config.globalProperties.$ethers = ethers;
app.mount('#app');
