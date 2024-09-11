from flask import Flask, jsonify
import numpy as np
import pandas as pd
from hmmlearn import hmm

app = Flask(__name__)

# Generate or load EV session data (for demonstration, we'll generate random data)
def generate_data():
    data = {
        'network_traffic': np.random.uniform(50, 500, 100),  # Random traffic
        'energy_usage': np.random.uniform(20, 100, 100),     # Random energy usage
        'event_type': np.random.choice(['NormalTraffic', 'AbnormalCommand'], 100)
    }
    df = pd.DataFrame(data)
    return df

# Train HMM model and return the probabilities
def train_hmm():
    df = generate_data()
    X = df[['network_traffic', 'energy_usage']].values

    # Train HMM with 2 states (Normal and Abnormal)
    model = hmm.GaussianHMM(n_components=2, covariance_type="diag", n_iter=100)
    model.fit(X)

    # Extract the transition matrix, means, and covariances
    transition_matrix = model.transmat_.tolist()
    means = model.means_.tolist()
    covariances = model.covars_.tolist()

    return transition_matrix, means, covariances

@app.route('/get_hmm_probabilities', methods=['GET'])
def get_hmm_probabilities():
    transition_matrix, means, covariances = train_hmm()
    return jsonify({
        'transition_matrix': transition_matrix,
        'means': means,
        'covariances': covariances
    })

if __name__ == '__main__':
    app.run(debug=True)
