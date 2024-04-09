oc delete secret muis_log_payload
oc create secret generic muis_log_payload   --from-file=./apicast-policy.json   --from-file=./init.lua   --from-file=./muis_log_payload.lua

#add the following properties in the APIManager yaml definition at the spec.apicast.stagingSpec.customPolicies
#        - name: muis_log_payload
#          secretRef:
#            name: muis_log_payload
#          version: '0.1'

oc rollout latest dc/apicast-staging

