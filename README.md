# Machine Learning with MATLAB

This repository contains a MATLAB-based Machine Learning Software (MLS) designed for biomedical signal processing. The software provides a graphical user interface (GUI) for processing and analyzing signals such as electroencephalography (EEG), electrocardiography (ECG), and electromyography (EMG). The MLS includes tools for filter design, feature extraction, dimensionality reduction, and machine learning algorithms.

**Related Article**:  
[A muscle synergies-based movements detection approach for recognition of the wrist movements](https://link.springer.com/article/10.1186/s13634-020-00699-y)

![Image](https://github.com/user-attachments/assets/d28e8e58-4e6c-49bf-9925-ae377c2413a0)

## Features

- **Data Preprocessing**: Import data from various formats (e.g., `.mat`, `.txt`, `.xlsx`), select channels, and apply denoising and filtering techniques.
- **Feature Extraction**: Extract features in both time and frequency domains using methods like Mean Absolute Value (MAV), Root Mean Square (RMS), and Wavelet transforms.
- **Feature Selection**: Utilize algorithms such as Principal Component Analysis (PCA), Fisher's Discriminate Analysis (FDA), and Mutual Information for optimal feature selection.
- **Classification & Clustering**: Apply supervised (e.g., SVM, KNN, MLP) machine learning algorithms.
- **Performance Evaluation**: Assess model performance using metrics like Accuracy, Sensitivity, Specificity, and F-score.

## Software Outline

1. **Step 1 & 2**: Import data, perform channel selection, and apply denoising and filtering (e.g., Notch Filter, Butterworth Filter).
2. **Step 3 & 4**: Extract features in time and frequency domains and select optimal features.
3. **Step 5**: Apply supervised machine learning techniques and assess their performance through different metrics.

## Abbreviations

- **Filtering**: Sampling frequency (Fs), lower cutoff frequency (Flow), higher cutoff frequency (Fhigh), Passband ripple (Rp), Stopband attenuation (Rs).
- **Feature Extraction**: Mean Absolute Value (MAV), Root Mean Square (RMS), Waveform length (WL), etc.
- **Feature Selection**: PCA, FDA, Mutual Information, etc.
- **Classification & Clustering**: SVM, KNN, MLP, K-means, etc.
- **Performance**: Accuracy, Sensitivity, Specificity, F-score, etc.

## Usage

1. Clone the repository:
   ```bash
   git clone https://github.com/RezaSaadatyar/Machine-Learning-with-MATLAB.git
   ```
2. Open MATLAB and navigate to the cloned directory.
3. Run the `main.m` file to launch the graphical user interface.

## Contributing

Contributions are welcome! Please fork the repository and submit a pull request with your changes.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contact

For any questions or support, please contact Reza.Saadatyar@outlook.com

