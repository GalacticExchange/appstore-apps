echo "---------- Test Container"
config=../config/config.json rake serverspec:rocana
#config=../config/config.json rspec spec/rocana/rocana_container_spec.rb
