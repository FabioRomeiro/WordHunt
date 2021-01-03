<template>
	<div class="home">
		<GridInput v-model="grid" :width="15" :height="15" />
	</div>
</template>

<script>
import GridInput from "@/components/GridInput.vue";

export default {
	name: "Home",
	components: {
		GridInput
	},
	methods: {
		updateGrid(grid) {
			this.grid = grid;
		}
	},
	data() {
		return {
			grid: null
		}
	}
};
</script>

<style lang="scss" scoped>
.home {
	display: flex;
	align-items: center;
	justify-content: center;
}
</style>
