import torch.nn as nn
import torchvision.models as models
from torchvision.models import ResNet50_Weights

class RetinaMultiTaskModel(nn.Module):
    def __init__(self, num_grade_classes=4, num_edema_classes=3):
        super().__init__()
        weights = ResNet50_Weights.IMAGENET1K_V1  # or .DEFAULT
        self.backbone = models.resnet50(weights=weights)
        in_features = self.backbone.fc.in_features
        self.backbone.fc = nn.Identity()

        self.grade_head = nn.Linear(in_features, num_grade_classes)
        self.edema_head = nn.Linear(in_features, num_edema_classes)

    def forward(self, x):
        features = self.backbone(x)
        grade_logits = self.grade_head(features)
        edema_logits = self.edema_head(features)
        return grade_logits, edema_logits