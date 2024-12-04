apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
    labels:
        app.kubernetes.io/instance: datadog
        app.kubernetes.io/managed-by: datadog-operator
        app.kubernetes.io/name: datadog-agent-deployment
        app.kubernetes.io/part-of: default-datadog
        app.kubernetes.io/version: ""
        operator.datadoghq.com/managed-by-store: "true"
    name: default-datadog-ksm-core-dca
rules:
    - apiGroups:
        - ""
      resources:
        - configmaps
        - endpoints
        - events
        - limitranges
        - namespaces
        - nodes
        - persistentvolumeclaims
        - persistentvolumes
        - pods
        - replicationcontrollers
        - resourcequotas
        - secrets
        - services
      verbs:
        - list
        - watch
    - apiGroups:
        - extensions
      resources:
        - daemonsets
        - deployments
        - replicasets
      verbs:
        - list
        - watch
    - apiGroups:
        - apps
      resources:
        - daemonsets
        - deployments
        - replicasets
        - statefulsets
      verbs:
        - list
        - watch
    - apiGroups:
        - batch
      resources:
        - cronjobs
        - jobs
      verbs:
        - list
        - watch
    - apiGroups:
        - autoscaling
      resources:
        - horizontalpodautoscalers
      verbs:
        - list
        - watch
    - apiGroups:
        - policy
      resources:
        - poddisruptionbudgets
      verbs:
        - list
        - watch
    - apiGroups:
        - certificates.k8s.io
      resources:
        - certificatesigningrequests
      verbs:
        - list
        - watch
    - apiGroups:
        - storage.k8s.io
      resources:
        - storageclasses
        - volumeattachments
      verbs:
        - list
        - watch
    - apiGroups:
        - admissionregistration.k8s.io
      resources:
        - mutatingwebhookconfigurations
        - validatingwebhookconfigurations
      verbs:
        - list
        - watch
    - apiGroups:
        - networking.k8s.io
      resources:
        - ingresses
        - networkpolicies
      verbs:
        - list
        - watch
    - apiGroups:
        - coordination.k8s.io
      resources:
        - leases
      verbs:
        - list
        - watch
    - apiGroups:
        - autoscaling.k8s.io
      resources:
        - verticalpodautoscalers
      verbs:
        - list
        - watch

apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
    labels:
        app.kubernetes.io/instance: datadog
        app.kubernetes.io/managed-by: datadog-operator
        app.kubernetes.io/name: datadog-agent-deployment
        app.kubernetes.io/part-of: default-datadog
        app.kubernetes.io/version: ""
        operator.datadoghq.com/managed-by-store: "true"
    name: datadog-agent
rules:
    - apiGroups:
        - ""
      resources:
        - nodes/metrics
        - nodes/spec
        - nodes/proxy
        - nodes/stats
      verbs:
        - get
    - apiGroups:
        - ""
      resources:
        - endpoints
      verbs:
        - get
    - apiGroups:
        - coordination.k8s.io
      resources:
        - leases
      verbs:
        - get
    - nonResourceURLs:
        - /metrics
        - /metrics/slis
      verbs:
        - get
