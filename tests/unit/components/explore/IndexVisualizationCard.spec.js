import { createLocalVue, shallowMount } from '@vue/test-utils'
import VisualizationCard from '@/components/explore/IndexVisualizationCard.vue'
import BootstrapVue from 'bootstrap-vue'

const localVue = createLocalVue()
localVue.use(BootstrapVue)

describe('VisualizationCard.vue', () => {
  it('renders the correct markup', () => {
    const wrapper = shallowMount(
      VisualizationCard,
      {
        localVue,
        propsData: {
          image: 'test.png',
          link: '/test',
          text: 'Test',
          title: 'Test'
        }
      }
    )

    expect(wrapper.contains('img')).toBe(true)
  })
})
