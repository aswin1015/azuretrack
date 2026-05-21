# Domain Based Routing with Application Gateway WAF + Private VMs + NAT Gateway

# Architecture

```text
Internet
   │
   ▼
DNS
   │
   ▼
Application Gateway WAF v2
   │
   ├── maheshrevs.online → frontend-vm
   │
   └── api.maheshrevs.online → api-vm
                    │
                    ▼
                 NAT Gateway
                    │
                    ▼
              Internet Access
```

---

# Step 1 — Create Resource Group

Go to:

```text
Azure Portal
→ Resource Groups
→ Create
```

Fill:

```text
Resource Group Name : Mahesh-RG
Region              : Central India
```

Click:

```text
Review + Create
```

---

# Step 2 — Create Virtual Network

Go to:

```text
Virtual Networks
→ Create
```

Fill:

```text
Name            : Mahesh-VNet
Region          : Central India
Address Space   : 10.0.0.0/16
```

Create two subnets:

## Subnet 1

```text
Name : appgw-subnet
CIDR : 10.0.1.0/24
```

## Subnet 2

```text
Name : vm-subnet
CIDR : 10.0.2.0/24
```

Click:

```text
Review + Create
```

---

# Step 3 — Create Network Security Group

Go to:

```text
Network Security Groups
→ Create
```

Fill:

```text
Name   : Mahesh-NSG
Region : Central India
```

Create.

---

# Step 4 — Add NSG Rules

Inside NSG:

```text
Inbound Security Rules
→ Add
```

## Allow HTTP

```text
Port     : 80
Protocol : TCP
Action   : Allow
Priority : 100
```

## Allow HTTPS

```text
Port     : 443
Protocol : TCP
Action   : Allow
Priority : 110
```

## Allow SSH

```text
Port     : 22
Protocol : TCP
Action   : Allow
Priority : 120
```

---

# Step 5 — Associate NSG with VM Subnet

Go to:

```text
Mahesh-NSG
→ Subnets
→ Associate
```

Choose:

```text
VNet   : Mahesh-VNet
Subnet : vm-subnet
```

Save.

---

# Step 6 — Create Frontend VM

Go to:

```text
Virtual Machines
→ Create
```

Fill:

```text
VM Name             : frontend-vm
Region              : Central India
Availability Zone   : Zone 3
Image               : Ubuntu 22.04 Gen2
Size                : Standard_DC1ds_v3
Authentication Type : Password
Username            : Mahesh
Password            : Mahesh@050903
```

Networking:

```text
VNet      : Mahesh-VNet
Subnet    : vm-subnet
Public IP : None
NSG       : Mahesh-NSG
```

Create VM.

---

# Step 7 — Create API VM

Repeat same process.

Change only:

```text
VM Name : api-vm
```

Everything else remains same.

---

# Step 8 — Create Public IP for NAT Gateway

Go to:

```text
Public IP Addresses
→ Create
```

Fill:

```text
Name               : nat-pip
Region             : Central India
SKU                : Standard
Assignment         : Static
Availability Zone  : Zone 3
```

Create.

---

# Step 9 — Create NAT Gateway

Go to:

```text
NAT Gateway
→ Create
```

Fill:

```text
Name            : Mahesh-NAT
Region          : Central India
Resource Group  : Mahesh-RG
```

Under Outbound IP:

```text
Select nat-pip
```

Create NAT Gateway.

---

# Step 10 — Associate NAT Gateway with VM Subnet

Go to:

```text
Mahesh-NAT
→ Subnets
→ Associate
```

Choose:

```text
VNet   : Mahesh-VNet
Subnet : vm-subnet
```

Save.

---

# Step 11 — Verify Outbound Internet

SSH into VM using Bastion or Azure Serial Console.

Run:

```bash
sudo apt update
```

OR

```bash
curl google.com
```

Now internet access works through NAT Gateway.

---

# Step 12 — Install Application in frontend-vm

SSH into frontend-vm.

Run:

```bash
sudo apt update -y
sudo apt install nginx nodejs npm git -y

cd /home/Mahesh

git clone https://github.com/Msocial123/organic-ghee.git

cd organic-ghee

npm install

nohup node src/app.js > app.log 2>&1 &
```

---

# Step 13 — Install Application in api-vm

SSH into api-vm.

Run:

```bash
sudo apt update -y
sudo apt install nginx -y

echo "<h1>API SERVER</h1>" | sudo tee /var/www/html/index.html
```

---

# Step 14 — Create Public IP for Application Gateway

Go to:

```text
Public IP Addresses
→ Create
```

Fill:

```text
Name               : appgw-pip
Region             : Central India
SKU                : Standard
Assignment         : Static
Availability Zone  : Zone 3
```

Create.

---

# Step 15 — Create WAF Policy

Go to:

```text
WAF Policies
→ Create
```

Fill:

```text
Name  : Mahesh-WAF
Type  : Application Gateway
Mode  : Prevention
```

Create.

---

# Step 16 — Create Application Gateway WAF v2

Go to:

```text
Application Gateways
→ Create
```

## Basics

```text
Name              : Mahesh-AppGW
Region            : Central India
Tier              : WAF V2
Autoscaling       : Enabled
Min Instances     : 1
Max Instances     : 5
```

## Frontend

```text
Frontend Type : Public
Public IP     : appgw-pip
Port          : 80
```

## Backend Pools

### Pool 1

```text
Pool Name : frontend-pool
Target    : frontend-vm private IP
```

### Pool 2

```text
Pool Name : api-pool
Target    : api-vm private IP
```

---

# Step 17 — Configure Routing Rules

## Rule 1

```text
Rule Name      : frontend-rule
Listener Type  : Multi Site
Hostname       : maheshrevs.online
Backend Pool   : frontend-pool
Backend Port   : 80
```

## Rule 2

```text
Rule Name      : api-rule
Listener Type  : Multi Site
Hostname       : api.maheshrevs.online
Backend Pool   : api-pool
Backend Port   : 80
```

---

# Step 18 — Attach WAF Policy

Inside Application Gateway:

```text
Select Existing WAF Policy
→ Mahesh-WAF
```

Create Application Gateway.

Deployment time:

```text
10–20 minutes
```

---

# Step 19 — Configure DNS

Go to your domain provider.

Create A records:

## Root Domain

```text
Type  : A
Host  : @
Value : Application Gateway Public IP
```

## API Subdomain

```text
Type  : A
Host  : api
Value : Application Gateway Public IP
```

Save DNS records.

---

# Step 20 — Verify

Open:

```text
http://maheshrevs.online
```

Should open:

```text
frontend-vm application
```

Open:

```text
http://api.maheshrevs.online
```

Should open:

```text
api-vm application
```

---

# Final Production Architecture

```text
Internet
   │
   ▼
DNS
   │
   ▼
Application Gateway WAF v2
   │
   ├── frontend-vm
   │
   └── api-vm
          │
          ▼
     NAT Gateway
          │
          ▼
   Outbound Internet
```