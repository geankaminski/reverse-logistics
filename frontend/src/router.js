import { createWebHistory, createRouter } from 'vue-router';
import TheHome from '@/views/TheHome.vue';
import TheContainers from '@/views/TheContainers.vue';
import TheDelivery from '@/views/TheDelivery.vue';
import TheCollect from '@/views/TheCollect.vue';

const routes = [
    {
        path: '/',
        name: 'TheHome',
        component: TheHome,
    },
    {
        path: '/containers',
        name: 'TheContainers',
        component: TheContainers,
    },
    {
        path: '/delivery',
        name: 'TheDelivery',
        component: TheDelivery,
    },
    {
        path: '/collect',
        name: 'TheCollect',
        component: TheCollect,
    },
];

const router = createRouter({
    history: createWebHistory(),
    routes,
});

export default router;