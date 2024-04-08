oc delete secret muisrespbody
oc create secret generic muisrespbody   --from-file=./apicast-policy.json   --from-file=./init.lua   --from-file=./muisrespbody.lua

#add the following properties in the APIManager yaml definition at the spec.apicast.stagingSpec.customPolicies
#        - name: muisrespbody
#          secretRef:
#            name: muisrespbody
#          version: '0.1'

oc rollout latest dc/apicast-staging

