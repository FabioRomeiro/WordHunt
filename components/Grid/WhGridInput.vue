<template>
	<div class="wh-grid-input">
		<div v-for="(nx, rowIndex) in height" :key="rowIndex" class="wh-grid-input__row">
			<input
				v-for="(ny, columnIndex) in height"
				:ref="getRefName(rowIndex, columnIndex)"
				:key="columnIndex" 
				v-model="grid[rowIndex][columnIndex]"
				maxlength="1"
				class="wh-grid-input__field" 
				@keydown="onKeyDown(rowIndex, columnIndex, $event)"
				@keypress="onKeyPress(rowIndex, columnIndex, $event)"
				@input.stop="onInput(rowIndex, columnIndex, $event)"
			/>
		</div>
	</div>
</template>

<script>
export default {
	name: "GridInput",
	props: {
		modelValue: {
            type: Object,
            default: () => ({})
        },
		width: {
            type: Number,
            default: 15
        },
		height: {
            type: Number,
            default: 15
        }
	},
	data() {
		return {
			grid: Array.from(Array(this.height), () => Array.from(Array(this.width)))
		}
	},
	methods: {
		getRefName(row, column) {
			return `${row},${column}`
		},
		onKeyPress(rowIndex, columnIndex) {
			this.$set(this.grid[rowIndex], columnIndex, '')
		},
		onKeyDown(rowIndex, columnIndex, event) {
			const key = event.key
			const arrowKeys = ['ArrowDown', 'ArrowUp', 'ArrowLeft', 'ArrowRight']
			const extremeNavigationMap = {
				'Home': 'Left',
				'End': 'Right',
				'PageDown': 'Down',
				'PageUp': 'Up',
			}

			if (arrowKeys.includes(key)) {
				this.focusOnNextField(rowIndex, columnIndex, key.replace('Arrow', ''))
			}
			else if (key in extremeNavigationMap) {
				this.focusOnNextField(rowIndex, columnIndex, extremeNavigationMap[key], true)
			}

			const isCleaningField = key === 'Backspace' || key === 'Delete'

			if (key === 'Backspace') {
				this.focusOnNextField(rowIndex, columnIndex, 'Left')
			}
			else if (key === 'Delete') {
				this.focusOnNextField(rowIndex, columnIndex, 'Right')
			}

			if (isCleaningField) {
				this.$set(this.grid[rowIndex], columnIndex, '')
				event.preventDefault()
			}
		},
		onInput(rowIndex, columnIndex, event) {
			const char = event.data.toUpperCase()
			this.$set(this.grid[rowIndex], columnIndex, char)
			this.focusOnNextField(rowIndex, columnIndex)
			this.$emit('update:modelValue', this.grid)
		},
		focusOnNextField(curRowIndex, curColumnIndex, direction = 'Right', allTheWay = false) {
			let nextFieldColumn = curColumnIndex
			let nextFieldRow = curRowIndex
			const isRight = direction === 'Right'
			const isLeft = direction === 'Left'
			const isUp = direction === 'Up'
			const isDown = direction === 'Down'

			if (isRight && allTheWay) {
				nextFieldColumn = this.width - 1
			}
			else if (isLeft && allTheWay) {
				nextFieldColumn = 0
			}
			else if (isDown && allTheWay) {
				nextFieldRow = this.height - 1
			}
			else if (isUp && allTheWay) {
				nextFieldRow = 0
			}
			else if (isRight) {
				nextFieldColumn = curColumnIndex + 1
				if (curColumnIndex === this.width - 1) {
					nextFieldColumn = 0
					nextFieldRow = curRowIndex + 1

					if (curRowIndex === this.height - 1) {
						nextFieldRow = 0
					}
				}	
			}
			else if (isLeft) {
				nextFieldColumn = curColumnIndex - 1
				if (curColumnIndex === 0) {
					nextFieldColumn = this.width - 1
					nextFieldRow = curRowIndex - 1

					if (curRowIndex === 0) {
						nextFieldRow = this.height - 1
					}
				}	
			}
			else if (isDown) {
				nextFieldRow = curRowIndex + 1

				if (curRowIndex === this.height - 1) {
					nextFieldRow = 0
				}	
			}
			else if (isUp) {
				nextFieldRow = curRowIndex - 1

				if (curRowIndex === 0) {
					nextFieldRow = this.height - 1
				}	
			}
			const $inputElement = this.$refs[this.getRefName(nextFieldRow, nextFieldColumn)][0]
			$inputElement.focus()
		}
	}
}
</script>

<style scoped lang="scss">
.wh-grid-input {
	$field-border: black solid 1px;
	
	display: flex;
	flex-direction: column;
	
	&__row {
		display: flex;
		border-bottom: $field-border;

		&:first-child {
			border-top: $field-border;
		}
	}

	&__field {
		width: 20px;
		height: 20px;
		border-radius: 0;
		border: none;
		border-right: $field-border;
		text-transform: uppercase;
		text-align: center;

		&:first-child {
			border-left: $field-border;
		}
	}
}
</style>
