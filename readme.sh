oc delete secret muislogpayload
oc create secret generic muislogpayload   --from-file=./apicast-policy.json   --from-file=./init.lua   --from-file=./muislogpayload.lua

#add the following properties in the APIManager yaml definition at the spec.apicast.stagingSpec.customPolicies
#        - name: muislogpayload
#          secretRef:
#            name: muislogpayload
#          version: '0.1'

oc rollout latest dc/apicast-staging

