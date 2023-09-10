library(igraph)

# SYNTHETIC  DATA  GENERATION #

?watts.strogatz.game

#A Watts-Strogatz network with 10 nodes is created. 
#Each node is initially connected to its k nearest neighbors on a ring lattice. 
#With a probability of p, each edge is then rewired to a random node in the network,which creates the small-world effect.
#The loops = FALSE argument ensures that self-loops are not allowed.

# Parameters for the Watts-Strogatz model
n <- 10  # Number of nodes
k <- 4  # Average degree (even number)
p <- 0.3 # Probability of rewiring

# Generate the Watts-Strogatz graph
g <- watts.strogatz.game(dim = 1, size = n, nei = k/2, p = p)

# Define node names
node_names <- c("firewall", "privacy_checks", "access_control", "authentication", "vulnerable_apps", "encryption", "security_policy", "identity", "patch_management", "threat_detection")

# Define department names
department_names <- c("IT_Infrastructure",
                      "Network_Operations",
                      "Application_Development",
                      "Data_Management",
                      "Information_Security",
                      "Human_Resources",
                      "Finance",
                      "Legal_Compliance",
                      "Customer_Support",
                      "Marketing",
                      "Research_Development",
                      "Sales",
                      "Supply_Chain",
                      "Operation",
                      "Project_Management",
                      "Executive_Management",
                      "Training",
                      "Quality_Assurance",
                      "Maintenance",
                      "Internal Audit")

# Randomly assign departments to nodes
departments <- sample(department_names, n, replace = TRUE)

# Randomly assign multiple departments to each node
node_departments <- lapply(departments, function(dept) sample(department_names, size = sample(1:3, 1)))

# Set node names and departments as node attributes
V(g)$name <- node_names
V(g)$department <- node_departments

# Print node names and departments
node_info <- data.frame(name = V(g)$name, department = sapply(V(g)$department, paste, collapse = "\n"))
print(node_info)

# Randomly select 5 highly influential nodes
influential_nodes <- sample(1:n, 5)

# Set color attribute for influential nodes
V(g)$color <- ifelse(1:n %in% influential_nodes, "red", "blue")

# Plot the graph
plot(g, vertex.size = 10, vertex.label = paste(V(g)$name, V(g)$department, sep = "\n"), vertex.color = V(g)$color)
plot(g)

A <- as.matrix(as_adjacency_matrix(g))
A

D <- colSums(A)
T <- A/D

(p0 = c(1,0,1,0,0,0,0,1,0,0)/3)
(p1 =T%*%p0)
(p2 =T%*%p1)
(p3 =T%*%p2)

Nsim = 50

p = p0
P = p

for(s in 2:Nsim){
  
  p = T%*%p
  P = cbind(P,p)
  
  plot(1:s, P[1,], type = 'l')
  
  for(i in 2:n){
    lines(1:s, P[i,], type = 'l')
  }
  
}

set.seed(123)
# INDEPENDENT CASCADE MODEL

#doing manually the first iteration to run whilr loop
l <- layout_with_fr(g)
l
Prob <- 1/igraph::degree(g)

Vertex.col <- rep(0,n)


Initial.nodes <- c(2,3,4)
Vertex.col[Initial.nodes] <- 4
V(g)$color <- Vertex.col
plot(g, layout= l, vertex.size=20, vertex.label = NA)
Active <- Initial.nodes
Explore <- TRUE
i <- 1
X <- A
g <- g

# running the while loop of independent cascade model
while(i <= n && Explore){
  
  if (i <= length(Active) && length(Active) < n){
    
    Candidate.nodes <- which(X[Active[i],]>0)
    
    New.Active <- NULL
    for(j in Candidate.nodes){
      Add.node <- rbinom(1,1,Prob[j])
      if(Add.node > 0){
        New.Active <- c(New.Active, j)
      }
    }
    
    print(c(Candidate.nodes, New.Active))
    
    Active <- unique(c(Active, New.Active))
    Vertex.col[Active] <- 4
    V(g)$color <- Vertex.col
    plot(g, layout= l, vertex.size=20, vertex.label = NA)
  }else{
    Explore <- FALSE
  }
  i <- i+1
  Sys.sleep(1)
  
}

# simulate the process function
#
#-----------------------------------------------------------

#putting all above steps in the function

simulate <- function(Seeds, g, Prob, display){
  
  # Plot the initial state
  
  if(display){
    Vertex.col <- rep(0,n)
    Vertex.col[Seeds] <- 4
    V(g)$color <- Vertex.col
    plot(g, layout= l, vertex.size=20, vertex.label = NA)
  }
  
  # Build the adjacency matrix
  
  X <- as.matrix(get.adjacency(g))
  
  Active <- Seeds
  Explore <- TRUE
  i <- 1
  while(i <= n && Explore){
    
    if (i <= length(Active) && length(Active) < n){
      
      Candidate.nodes <- which(X[Active[i],]>0)
      
      New.Active <- NULL
      for(j in Candidate.nodes){
        Add.node <- rbinom(1,1,Prob[j])
        if(Add.node > 0){
          New.Active <- c(New.Active, j)
        }
      }
      
      #print(c(Candidate.nodes, New.Active))
      
      Active <- unique(c(Active, New.Active))
      
      if(display){
        Vertex.col[Active] <- 4
        V(g)$color <- Vertex.col
        plot(g, layout= l, vertex.size=20, vertex.label = NA)
      }
      
    }else{
      Explore <- FALSE
    }
    i <- i+1
    Sys.sleep(0)
    
  }
  
  return(length(Active))
  
}

# Simulate the system multiple times starting 
# from the same initial seed
#----------------------------------------------

simulate(Initial.nodes, g, Prob, TRUE )

Nsim = 500
MyResults = rep(0,Nsim)

for(s in 1:Nsim){
  MyResults[s] = simulate(Initial.nodes, g, Prob, FALSE )
}

hist(MyResults, breaks = 100)

#----------------------------------------------
# Find the best initial node to maximize the 
# number of influenced nodes
#----------------------------------------------

#running the simulation function for 1000 iterations
Nsim = 5000

ICM_MeanCentrality = rep(0,n)
ICM_VarCentrality = rep(0,n)

for(MyNode in 1:n){
  
  Initial.nodes <- MyNode
  
  MyResults = rep(0,Nsim)
  
  for(s in 1:Nsim){
    MyResults[s] = simulate(Initial.nodes, g, Prob, FALSE )
  }
  
  hist(MyResults, breaks = 100, main = paste("Node", MyNode))
  
  ICM_MeanCentrality[MyNode] = mean(MyResults)
  ICM_VarCentrality[MyNode] = sd(MyResults)
  
}

ord = order(ICM_VarCentrality)

plot(ICM_VarCentrality[ord], ICM_MeanCentrality[ord], type = "o", lwd = 3)

#simulation of different nodes

# Define the number of nodes
Initial.nodes <- 10

# Initialize a vector to store the influence of each node
influence <- rep(0, n)

# Perform simulation for each node
for (Initial.nodes in 1:n) {
  n.infected <- 0
  
  # Simulate the influence for the current node
  for (i in 1:Initial.nodes) {
    n.infected <- n.infected + simulate(Initial.nodes, g, Prob, FALSE)
  }
  
  # Calculate and store the influence
  influence[Initial.nodes] <- n.infected / n
}

# Print the influence of each node
print(influence)










