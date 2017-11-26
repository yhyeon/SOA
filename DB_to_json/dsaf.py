l = []

for a in range(5):
    l.append(range(5))

m = 0
d = 1
for a in range(5):
    for s in range(5-a):
        l[a][s] = d
        if(m%2 == 0):
            a = a+1
        else:
            s = s+1
    m =

print(l)