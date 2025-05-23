import pandas as pd
import numpy as np
from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestRegressor
from sklearn.metrics import mean_squared_error, r2_score
import matplotlib.pyplot as plt

# -----------------------------
# Step 1: Load Data
# -----------------------------
df = pd.read_csv(r"C:\Users\Asus\OneDrive\Documents\MATLAB\New Folder\Final\UE_gNB_metrics.csv")



# Define features and target
features = ['RSSI', 'SINR', 'Throughput', 'HARQ_retx', 'CQI', 'Latency', 'Jitter']
target = 'RBs'

# Check for missing data
if df.isnull().values.any():
    print("Missing values found. Filling with mean.")
    df.fillna(df.mean(), inplace=True)

# -----------------------------
# Step 2: Split Data by gNB_ID (Federated Clients)
# -----------------------------
clients = {}
for gnb_id in sorted(df['gNB_ID'].unique()):
    df_client = df[df['gNB_ID'] == gnb_id]
    if len(df_client) < 10:
        continue  # Skip small sets
    X_train, X_test, y_train, y_test = train_test_split(df_client[features], df_client[target], test_size=0.3, random_state=gnb_id)
    clients[gnb_id] = (X_train, X_test, y_train, y_test)

print(f"Total federated clients: {len(clients)}")

# -----------------------------
# Step 3: Train Local Models
# -----------------------------
models = {}
for client_id, (X_train, X_test, y_train, y_test) in clients.items():
    model = RandomForestRegressor(n_estimators=50, random_state=client_id)
    model.fit(X_train, y_train)
    models[client_id] = model
    print(f"Client {client_id}: Local model trained")

# -----------------------------
# Step 4: Federated Ensemble Prediction
# -----------------------------
# Combine global test set
global_X = pd.concat([clients[i][1] for i in clients])
global_y = pd.concat([clients[i][3] for i in clients])

# Predict and average from all models
ensemble_predictions = np.mean([model.predict(global_X) for model in models.values()], axis=0)

# Evaluation
mse = mean_squared_error(global_y, ensemble_predictions)
r2 = r2_score(global_y, ensemble_predictions)
print(f"\nFederated Ensemble Evaluation:")
print(f"Mean Squared Error (MSE): {mse:.2f}")
print(f"R2 Score: {r2:.2f}")

# -----------------------------
# Step 5: Visualization
# -----------------------------
plt.figure(figsize=(8, 5))
plt.scatter(global_y, ensemble_predictions, alpha=0.6, c='blue', label='Predicted vs Actual')
plt.plot([global_y.min(), global_y.max()], [global_y.min(), global_y.max()], 'r--', lw=2, label='Ideal Fit')
plt.xlabel("Actual RBs")
plt.ylabel("Predicted RBs")
plt.title("Federated Learning: Resource Block Allocation Prediction")
plt.legend()
plt.grid(True)
plt.tight_layout()
plt.savefig("federated_prediction_plot.png")
plt.show()
