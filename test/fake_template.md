
## <%= request.method %> <%= request.path %>
<%= note %>

### Params
```json
<%= JSON.pretty_generate(request.params.reject{|k,v| ["format", "action", "controller"].include?(k)}) %>
```

### Result
```json
<%= JSON.pretty_generate(JSON.parse(response.body)) %>
```
