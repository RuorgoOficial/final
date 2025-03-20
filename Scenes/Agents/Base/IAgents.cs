using Final.Shared;
using Godot;

namespace Final.Scenes.Agents.Base
{
    public interface IAgents<T>
        where T : BaseStats
    {
        public int GetHp();
        public void Attack();
        public void GainExp(int receivedExp);
        public void GrownLevel();
        
    }
}