using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Final.Shared
{
    public class BaseStats
    {
        public int HP {get; set;}
        public int CurrentHp {get; set;}
        public int Strenght {get; set;}
        public int Vitality {get; set;}
        public int Agility {get; set;}
        public int Defense {get; set;}

        public int level { get; set; } = 1;
        public int level_exp { get; set; } = 0;
        public int total_exp { get; set; } = 100;
    }
}
