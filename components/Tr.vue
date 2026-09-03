<script setup lang="ts">
import { configs } from '@slidev/client'

// Toggle from slides.md headmatter:  showTranslations: false
const show = (configs as Record<string, unknown>).showTranslations !== false
</script>

<template>
  <div v-if="show" class="tr-caption">
    <slot />
  </div>
</template>

<style scoped>
.tr-caption {
  position: absolute;
  left: 0;
  right: 0;
  bottom: 1.6rem;
  padding: 0 3rem;
  text-align: center;
  font-size: 0.9rem;
  line-height: 1.45;
  opacity: 0.5;
  font-family: ui-sans-serif, system-ui, -apple-system, sans-serif;
  font-weight: 400;
  pointer-events: none;
}
</style>
