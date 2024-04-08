oc delete secret muis-resp-body
oc create secret generic muis-resp-body   --from-file=./apicast-policy.json   --from-file=./init.lua   --from-file=./muis_resp_body.lua

#add the following properties in the APIManager yaml definition at the spec.apicast.stagingSpec.customPolicies
#        - name: muis_resp_body
#          secretRef:
#            name: muis_resp_body
#          version: '0.1'

oc rollout latest dc/apicast-staging

